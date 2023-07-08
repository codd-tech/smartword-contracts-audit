// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ScheduledTokenSale.sol";

/**
 * @title Advisors SWGT sale schedule
 * @author https://codd.tech
 * @dev See ScheduledTokenSale contract for details
 */
contract AdvisorsTokenSale is ScheduledTokenSale {
    // solhint-disable-next-line no-empty-blocks
    constructor(IERC20 token) ScheduledTokenSale(token) {}

    function _initUnlockSchedule() internal override {
        unlockSchedule.push(UnlockScheduleItem(360 days, 2000));
        unlockSchedule.push(UnlockScheduleItem(450 days, 3000));
        unlockSchedule.push(UnlockScheduleItem(540 days, 4000));
        unlockSchedule.push(UnlockScheduleItem(630 days, 5000));
        unlockSchedule.push(UnlockScheduleItem(720 days, 7000));
        unlockSchedule.push(UnlockScheduleItem(810 days, 8000));
        unlockSchedule.push(UnlockScheduleItem(900 days, 10000));
    }
}
