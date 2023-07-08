// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ScheduledTokenSale.sol";

/**
 * @title Team SWGT sale schedule
 * @author https://codd.tech
 * @dev See ScheduledTokenSale contract for details
 */
contract TeamTokenSale is ScheduledTokenSale {
    // solhint-disable-next-line no-empty-blocks
    constructor(IERC20 token) ScheduledTokenSale(token) {}

    function _initUnlockSchedule() internal override {
        unlockSchedule.push(UnlockScheduleItem(300 days, 2000));
        unlockSchedule.push(UnlockScheduleItem(390 days, 4000));
        unlockSchedule.push(UnlockScheduleItem(480 days, 6000));
        unlockSchedule.push(UnlockScheduleItem(570 days, 8000));
        unlockSchedule.push(UnlockScheduleItem(660 days, 10000));
    }
}
