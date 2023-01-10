// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ScheduledTokenSale.sol";

/**
 * @title Team SWGT sale schedule
 * @author https://codd.tech
 * @dev See ScheduledTokenSale contract for details
 */
contract TeamTokenSale is ScheduledTokenSale {
    // solhint-disable-next-line no-empty-blocks, not-rely-on-time
    constructor(IERC20 token) ScheduledTokenSale(token, block.timestamp) {}

    function _initUnlockSchedule() internal override {
        unlockSchedule.push(UnlockScheduleItem(0 days, 1450));
        unlockSchedule.push(UnlockScheduleItem(28 days, 1650));
        unlockSchedule.push(UnlockScheduleItem(60 days, 1725));
        unlockSchedule.push(UnlockScheduleItem(90 days, 1850));
        unlockSchedule.push(UnlockScheduleItem(120 days, 2150));
        unlockSchedule.push(UnlockScheduleItem(150 days, 2375));
        unlockSchedule.push(UnlockScheduleItem(180 days, 2450));
        unlockSchedule.push(UnlockScheduleItem(210 days, 2750));
        unlockSchedule.push(UnlockScheduleItem(240 days, 3100));
        unlockSchedule.push(UnlockScheduleItem(270 days, 3175));
        unlockSchedule.push(UnlockScheduleItem(300 days, 3750));
        unlockSchedule.push(UnlockScheduleItem(330 days, 4075));
        unlockSchedule.push(UnlockScheduleItem(360 days, 4400));
        unlockSchedule.push(UnlockScheduleItem(390 days, 4725));
        unlockSchedule.push(UnlockScheduleItem(420 days, 5300));
        unlockSchedule.push(UnlockScheduleItem(450 days, 5375));
        unlockSchedule.push(UnlockScheduleItem(480 days, 5950));
        unlockSchedule.push(UnlockScheduleItem(510 days, 6275));
        unlockSchedule.push(UnlockScheduleItem(540 days, 6600));
        unlockSchedule.push(UnlockScheduleItem(570 days, 6925));
        unlockSchedule.push(UnlockScheduleItem(600 days, 7500));
        unlockSchedule.push(UnlockScheduleItem(630 days, 7575));
        unlockSchedule.push(UnlockScheduleItem(660 days, 8150));
        unlockSchedule.push(UnlockScheduleItem(690 days, 8225));
        unlockSchedule.push(UnlockScheduleItem(720 days, 8550));
        unlockSchedule.push(UnlockScheduleItem(750 days, 8875));
        unlockSchedule.push(UnlockScheduleItem(780 days, 9200));
        unlockSchedule.push(UnlockScheduleItem(810 days, 9275));
        unlockSchedule.push(UnlockScheduleItem(840 days, 9600));
        unlockSchedule.push(UnlockScheduleItem(870 days, 9675));
        unlockSchedule.push(UnlockScheduleItem(900 days, 9750));
        unlockSchedule.push(UnlockScheduleItem(930 days, 9825));
        unlockSchedule.push(UnlockScheduleItem(960 days, 9900));
        unlockSchedule.push(UnlockScheduleItem(990 days, 10000));
    }
}
