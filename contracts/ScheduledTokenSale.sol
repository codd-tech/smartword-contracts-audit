// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title Abstract ScheduledTokenSale
 * @author https://codd.tech
 * @dev ScheduledTokenSale implements swapping unlocking schedule for early investors.
 * Unlock schedule managed by unlockSchedule and scheduleStartTimestamp variables.
 */
abstract contract ScheduledTokenSale is AccessControl {
    using SafeERC20 for IERC20;

    event Deposit(
        address sender,
        address indexed to,
        uint256 amount
    );

    bytes32 public constant CONTROLLER_ROLE = keccak256("CONTROLLER_ROLE");
    uint16 private constant PERCENT_DENOMINATOR = 10_000;

    uint256 public scheduleStartTimestamp = 0;

    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _withdrawnBalances;

    uint256 public totalBalance;

    struct UnlockScheduleItem {
        uint256 unlockTimePass;
        uint16 totalPercentageUnlocked;
    }

    UnlockScheduleItem[] internal unlockSchedule;

    IERC20 public token;

    function _initUnlockSchedule() internal virtual;

    constructor(IERC20 token_) {
        require(
            address(token_) != address(0),
            "ScheduledTokenSale: New token address cannot be null"
        );

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(CONTROLLER_ROLE, DEFAULT_ADMIN_ROLE);

        token = token_;

        _initUnlockSchedule();
        _validateUnlockSchedule();
    }

    function launchSale() external onlyRole(CONTROLLER_ROLE) {
        require(scheduleStartTimestamp == 0, "ScheduledTokenSale: Sale already launched");
        // solhint-disable-next-line not-rely-on-time
        scheduleStartTimestamp = block.timestamp;
    }

    function addBalance(
        address to,
        uint256 amount
    ) external virtual onlyRole(CONTROLLER_ROLE) {
        _addBalance(to, amount);
    }

    function withdraw(address to, uint256 amount) external returns (bool) {
        require(
            to != address(0),
            "ScheduledTokenSale: Recipient address cannot be null"
        );
        require(
            amount > 0,
            "ScheduledTokenSale: Withdraw amount must be greater than zero"
        );
        require(
            scheduleStartTimestamp > 0 && scheduleStartTimestamp < block.timestamp, // solhint-disable-line not-rely-on-time
            "ScheduledTokenSale: Unlock schedule not started yet"
        );
        require(
            unlockedOf(msg.sender) >= amount,
            "ScheduledTokenSale: Amount to withdraw is greater than unlocked amount"
        );

        _withdrawnBalances[msg.sender] += amount;
        totalBalance -= amount;
        token.safeTransfer(to, amount);
        return true;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account] - _withdrawnBalances[account];
    }

    function unlockedOf(address account) public view returns (uint256) {
        if (scheduleStartTimestamp > 0) {
            uint256 totalUnlocked = Math.mulDiv(
                _balances[account],
                getUnlockedPercent(block.timestamp - scheduleStartTimestamp), // solhint-disable-line not-rely-on-time
                PERCENT_DENOMINATOR
            );

            if (totalUnlocked <= _withdrawnBalances[account]) {
                return 0;
            }

            return totalUnlocked - _withdrawnBalances[account];
        }

        return 0;
    }

    function getUnlockedPercent(
        uint256 secondsPassed
    ) internal view returns (uint16) {
        uint8 index = 0;
        while(index < unlockSchedule.length && unlockSchedule[index].unlockTimePass < secondsPassed) { index++; }

        return index > 0 ? unlockSchedule[index - 1].totalPercentageUnlocked : 0;
    }

    function _addBalance(address to, uint256 amount) internal {
        require(
            to != address(0),
            "ScheduledTokenSale: Recipient address cannot be null"
        );
        require(
            amount > 0,
            "ScheduledTokenSale: Balance amount must be greater than zero"
        );
        require(
            totalBalance + amount <= token.balanceOf(address(this)),
            "ScheduledTokenSale: Total balance exceeds available balance"
        );

        _balances[to] += amount;
        totalBalance += amount;

        emit Deposit(msg.sender, to, amount);
    }

    function _validateUnlockSchedule() private view {
        assert(unlockSchedule.length > 1);
        assert(unlockSchedule[unlockSchedule.length - 1].totalPercentageUnlocked == PERCENT_DENOMINATOR);

        for (uint8 i = 1; i < unlockSchedule.length; ++i) {
            assert(
                unlockSchedule[i].totalPercentageUnlocked <= PERCENT_DENOMINATOR
            );
            assert(
                unlockSchedule[i - 1].unlockTimePass <
                    unlockSchedule[i].unlockTimePass
            );
            assert(
                unlockSchedule[i - 1].totalPercentageUnlocked <
                    unlockSchedule[i].totalPercentageUnlocked
            );
        }
    }
}
