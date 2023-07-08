// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ScheduledTokenSale.sol";

/**
 * @title Marketing SWGT sale schedule
 * @author https://codd.tech
 * @dev See ScheduledTokenSale contract for details
 */
contract MarketingTokenSale is ScheduledTokenSale {
    // solhint-disable-next-line no-empty-blocks
    constructor(IERC20 token) ScheduledTokenSale(token) {}

    function _initUnlockSchedule() internal override {
        unlockSchedule.push(UnlockScheduleItem(0 days, 2000));
        unlockSchedule.push(UnlockScheduleItem(120 days, 3000));
        unlockSchedule.push(UnlockScheduleItem(210 days, 4000));
        unlockSchedule.push(UnlockScheduleItem(300 days, 5000));
        unlockSchedule.push(UnlockScheduleItem(390 days, 6000));
        unlockSchedule.push(UnlockScheduleItem(480 days, 7000));
        unlockSchedule.push(UnlockScheduleItem(570 days, 8000));
        unlockSchedule.push(UnlockScheduleItem(660 days, 9000));
        unlockSchedule.push(UnlockScheduleItem(750 days, 10000));
    }
}
