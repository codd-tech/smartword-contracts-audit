// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ScheduledTokenSale.sol";

/**
 * @title Ecosystem SWGT sale schedule
 * @author https://codd.tech
 * @dev See ScheduledTokenSale contract for details
 */
contract EcosystemTokenSale is ScheduledTokenSale {
    // solhint-disable-next-line no-empty-blocks
    constructor(IERC20 token) ScheduledTokenSale(token) {}

    function _initUnlockSchedule() internal override {
        unlockSchedule.push(UnlockScheduleItem(0 days, 300));
        unlockSchedule.push(UnlockScheduleItem(28 days, 600));
        unlockSchedule.push(UnlockScheduleItem(60 days, 900));
        unlockSchedule.push(UnlockScheduleItem(120 days, 1200));
        unlockSchedule.push(UnlockScheduleItem(150 days, 1500));
        unlockSchedule.push(UnlockScheduleItem(180 days, 1800));
        unlockSchedule.push(UnlockScheduleItem(210 days, 2100));
        unlockSchedule.push(UnlockScheduleItem(240 days, 2400));
        unlockSchedule.push(UnlockScheduleItem(270 days, 2700));
        unlockSchedule.push(UnlockScheduleItem(300 days, 3000));
        unlockSchedule.push(UnlockScheduleItem(330 days, 3300));
        unlockSchedule.push(UnlockScheduleItem(360 days, 3600));
        unlockSchedule.push(UnlockScheduleItem(390 days, 3900));
        unlockSchedule.push(UnlockScheduleItem(420 days, 4200));
        unlockSchedule.push(UnlockScheduleItem(450 days, 4500));
        unlockSchedule.push(UnlockScheduleItem(480 days, 4800));
        unlockSchedule.push(UnlockScheduleItem(510 days, 5100));
        unlockSchedule.push(UnlockScheduleItem(540 days, 5400));
        unlockSchedule.push(UnlockScheduleItem(570 days, 5700));
        unlockSchedule.push(UnlockScheduleItem(600 days, 6000));
        unlockSchedule.push(UnlockScheduleItem(630 days, 6300));
        unlockSchedule.push(UnlockScheduleItem(660 days, 6600));
        unlockSchedule.push(UnlockScheduleItem(690 days, 6900));
        unlockSchedule.push(UnlockScheduleItem(720 days, 7200));
        unlockSchedule.push(UnlockScheduleItem(750 days, 7500));
        unlockSchedule.push(UnlockScheduleItem(780 days, 7800));
        unlockSchedule.push(UnlockScheduleItem(810 days, 8100));
        unlockSchedule.push(UnlockScheduleItem(840 days, 8400));
        unlockSchedule.push(UnlockScheduleItem(870 days, 8700));
        unlockSchedule.push(UnlockScheduleItem(900 days, 9000));
        unlockSchedule.push(UnlockScheduleItem(930 days, 9300));
        unlockSchedule.push(UnlockScheduleItem(960 days, 9600));
        unlockSchedule.push(UnlockScheduleItem(990 days, 10000));
    }
}
