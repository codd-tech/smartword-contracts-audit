// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ScheduledTokenSale.sol";

/**
 * @title Private SWGT sale schedule
 * @author https://codd.tech
 * @dev See ScheduledTokenSale contract for details
 */
contract PrivateTokenSale is ScheduledTokenSale {
    // solhint-disable-next-line no-empty-blocks
    constructor(IERC20 token) ScheduledTokenSale(token) {}

    function _initUnlockSchedule() internal override {
        unlockSchedule.push(UnlockScheduleItem(60 days, 2000));
        unlockSchedule.push(UnlockScheduleItem(240 days, 5000));
        unlockSchedule.push(UnlockScheduleItem(330 days, 6000));
        unlockSchedule.push(UnlockScheduleItem(420 days, 7000));
        unlockSchedule.push(UnlockScheduleItem(510 days, 8000));
        unlockSchedule.push(UnlockScheduleItem(600 days, 9000));
        unlockSchedule.push(UnlockScheduleItem(690 days, 10000));
    }
}
