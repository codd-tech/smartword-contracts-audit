// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ScheduledTokenSale.sol";
import "./LegacyToken.sol";

/**
 * @title Smartcontract for exchanging LegacyToken to SWGT with unlock schedule
 * @author https://codd.tech
 * @dev SeedTokenSale contract implements swapping Legacy tokens for SWGT and unlock schedule
 * SWG tokens are burned in the process.
 * It should be deployed in several steps:
 * 1. Deploy Exchanger with proper token addresses
 * 2. Transfer round cap to contract's address
 * Swap performed in two steps also:
 * 1. User should approve required amount to swap to the SeedTokenSale
 * 2. User should call SeedTokenSale.convert method
 * 3. After some time, when funds unlocked according to schedule, user can call method SeedTokenSale.withdraw
 * see ScheduledTokenSale contract for details
 */
contract SeedTokenSale is ScheduledTokenSale, ReentrancyGuard {
    event TokenExchanged(address indexed from, address indexed to, uint256 amount);

    LegacyToken private tokenOld;

    constructor(
        IERC20 token,
        LegacyToken tokenOld_
    ) ScheduledTokenSale(token) {
        require(
            address(tokenOld_) != address(0),
            "SeedTokenSale: Old token address cannot be null"
        );

        tokenOld = tokenOld_;
    }

    function convert(
        address to,
        uint256 amount
    ) external virtual returns (bool) {
        _convert(msg.sender, to, amount);
        return true;
    }

    function convert(
        address[] calldata to,
        uint256[] calldata amount
    ) external virtual onlyRole(CONTROLLER_ROLE) returns (bool) {
        require(
            to.length == amount.length,
            "SeedTokenSale: Number of recipients should match number of amounts"
        );
        require(to.length > 0, "SeedTokenSale: No recipients");

        address tokenOldOwner = tokenOld.owner();
        for (uint256 i = 0; i < to.length; i++) {
            _convert(tokenOldOwner, to[i], amount[i]);
        }

        return true;
    }

    function _convert(
        address from,
        address to,
        uint256 amount
    ) internal virtual nonReentrant {
        require(
            tokenOld.balanceOf(from) >= amount,
            "SeedTokenSale: Insufficient LegacyToken balance"
        );
        require(
            tokenOld.allowance(from, address(this)) >= amount,
            "SeedTokenSale: Not enough LegacyToken allowance"
        );

        tokenOld.burnFrom(from, amount);
        _addBalance(to, amount);

        emit TokenExchanged(from, to, amount);
    }

    function _initUnlockSchedule() internal override {
        unlockSchedule.push(UnlockScheduleItem(28 days, 1000));
        unlockSchedule.push(UnlockScheduleItem(120 days, 2500));
        unlockSchedule.push(UnlockScheduleItem(210 days, 4000));
        unlockSchedule.push(UnlockScheduleItem(300 days, 5000));
        unlockSchedule.push(UnlockScheduleItem(390 days, 6000));
        unlockSchedule.push(UnlockScheduleItem(480 days, 7000));
        unlockSchedule.push(UnlockScheduleItem(570 days, 8000));
        unlockSchedule.push(UnlockScheduleItem(660 days, 9000));
        unlockSchedule.push(UnlockScheduleItem(870 days, 10000));
    }
}
