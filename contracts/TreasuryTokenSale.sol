// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ScheduledTokenSale.sol";

/**
 * @title Treasury SWGT sale schedule
 * @author https://codd.tech
 * @dev See ScheduledTokenSale contract for details
 */
contract TreasuryTokenSale is ScheduledTokenSale {
    // solhint-disable-next-line no-empty-blocks
    constructor(IERC20 token) ScheduledTokenSale(token) {}

    function _initUnlockSchedule() internal override {
        unlockSchedule.push(UnlockScheduleItem(300 days, 1000));
        unlockSchedule.push(UnlockScheduleItem(360 days, 2000));
        unlockSchedule.push(UnlockScheduleItem(420 days, 3000));
        unlockSchedule.push(UnlockScheduleItem(480 days, 4000));
        unlockSchedule.push(UnlockScheduleItem(540 days, 5000));
        unlockSchedule.push(UnlockScheduleItem(600 days, 6000));
        unlockSchedule.push(UnlockScheduleItem(660 days, 7000));
        unlockSchedule.push(UnlockScheduleItem(720 days, 8000));
        unlockSchedule.push(UnlockScheduleItem(780 days, 9000));
        unlockSchedule.push(UnlockScheduleItem(840 days, 10000));
    }
}
