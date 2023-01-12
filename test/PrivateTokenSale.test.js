const { expect } = require('chai');
const { BN, constants, expectRevert, time, snapshot } = require('@openzeppelin/test-helpers');
const { ZERO_ADDRESS } = constants;

const PRIVATE_TOKEN_SALE_CAP = new BN('12000000000000000');
const DEFAULT_ADMIN_ROLE = '0x0000000000000000000000000000000000000000000000000000000000000000';
const CONTROLLER_ROLE = web3.utils.soliditySha3('CONTROLLER_ROLE');

const Token = artifacts.require('SWGT');
const PrivateTokenSale = artifacts.require('PrivateTokenSale');

contract('PrivateTokenSale', function ([owner, controller, account]) {
  beforeEach(async function () {
    this.token = await Token.new({ from: owner });
    this.tokenSale = await PrivateTokenSale.new(this.token.address, { from: owner });

    await this.tokenSale.grantRole(CONTROLLER_ROLE, controller, { from: owner });
    await this.token.transfer(this.tokenSale.address, PRIVATE_TOKEN_SALE_CAP, { from: owner });
  });

  describe('test initial state', async function () {
    it('balanceOf equals zero', async function () {
      expect(await this.tokenSale.balanceOf(owner)).to.be.bignumber.equal(BN(0));
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(BN(0));
    });

    it('unlockedOf equals zero', async function () {
      expect(await this.tokenSale.unlockedOf(owner)).to.be.bignumber.equal(BN(0));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN(0));
    });

    it('totalBalance equals zero', async function () {
      expect(await this.tokenSale.totalBalance()).to.be.bignumber.equal(BN(0));
    });

    it('scheduleStartTimestamp equals zero', async function () {
      expect(await this.tokenSale.scheduleStartTimestamp()).to.be.bignumber.equal(BN(0));
    });

    it('scheduleStartTimestamp equals zero', async function () {
      expect(await this.tokenSale.scheduleStartTimestamp()).to.be.bignumber.equal(BN(0));
    });

    it('unable to withdraw before schedule launch', async function () {
      await this.tokenSale.addBalance(account, 100, { from: controller });

      await expectRevert(
        this.tokenSale.withdraw(account, 10, { from: account }),
        'ScheduledTokenSale: Unlock schedule not started yet',
      );
    });

    it('unlockedOf equals zero before schedule launch', async function () {
      await this.tokenSale.addBalance(account, 100, { from: controller });
      expect(await this.tokenSale.unlockedOf(owner)).to.be.bignumber.equal(BN(0));
    });
  });

  describe('test access control', async function () {
    it('owner has default admin role', async function () {
      expect(await this.tokenSale.hasRole(DEFAULT_ADMIN_ROLE, owner)).to.be.equal(true);
    });

    it('controller role\'s admin is the default admin role', async function () {
      expect(await this.tokenSale.getRoleAdmin(CONTROLLER_ROLE)).to.be.equal(DEFAULT_ADMIN_ROLE);
    });

    it('only controller role can call addBalance', async function () {
      await expectRevert(
        this.tokenSale.addBalance(account, 100, { from: account }),
        'AccessControl: account ' + account.toLowerCase() + ' is missing role ' + CONTROLLER_ROLE,
      );

      await this.tokenSale.addBalance(account, 100, { from: controller });
    });

    it('only controller role can call launchSale', async function () {
      await expectRevert(
        this.tokenSale.launchSale({ from: account }),
        'AccessControl: account ' + account.toLowerCase() + ' is missing role ' + CONTROLLER_ROLE,
      );

      await this.tokenSale.launchSale({ from: controller });
    });
  });

  describe('#addBalance', async function () {
    it('recipient address cannot be null', async function () {
      await expectRevert(
        this.tokenSale.addBalance(ZERO_ADDRESS, 100, { from: controller }),
        'ScheduledTokenSale: Recipient address cannot be null',
      );
    });

    it('balance amount must be greater than zero', async function () {
      await expectRevert(
        this.tokenSale.addBalance(account, 0, { from: controller }),
        'ScheduledTokenSale: Balance amount must be greater than zero',
      );
    });

    it('total balance should not exceeds available balance', async function () {
      const availableBalance = await this.token.balanceOf(owner);

      await expectRevert(
        this.tokenSale.addBalance(account, availableBalance + BN('100'), { from: controller }),
        'ScheduledTokenSale: Total balance exceeds available balance',
      );
    });

    it('addBalance should update totalBalance', async function () {
      const amount = BN('100');
      await this.tokenSale.addBalance(account, amount, { from: controller });
      expect(await this.tokenSale.totalBalance()).to.be.bignumber.equal(amount);
    });
  });

  describe('#unlockedOf schedule', async function () {
    const amount = BN('100');

    let snapshot_;
    beforeEach(async function () {
      snapshot_ = await snapshot();
      await this.tokenSale.launchSale({ from: controller });
    });

    afterEach(async function () {
      await snapshot_.restore();
    });

    it('balanceOf returns available balance', async function () {
      await this.tokenSale.addBalance(account, amount, { from: controller });
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(amount);
    });

    it('unlockedOf returns zero on start', async function () {
      await this.tokenSale.addBalance(account, amount, { from: controller });
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(amount);
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('0'));
    });

    it('20% unlocked after 60 days', async function () {
      await this.tokenSale.addBalance(account, amount, { from: controller });
      await time.increase(time.duration.days(60).add(BN(1)));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('20'));
    });

    it('50% unlocked after 240 days', async function () {
      await this.tokenSale.addBalance(account, amount, { from: controller });
      await time.increase(time.duration.days(240).add(BN(1)));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('50'));
    });

    it('60% unlocked after 330 days', async function () {
      await this.tokenSale.addBalance(account, amount, { from: controller });
      await time.increase(time.duration.days(330).add(BN(1)));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('60'));
    });

    it('90% unlocked after 600 days', async function () {
      await this.tokenSale.addBalance(account, amount, { from: controller });
      await time.increase(time.duration.days(600).add(BN(1)));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('90'));
    });

    it('100% unlocked after 690 days', async function () {
      await this.tokenSale.addBalance(account, amount, { from: controller });
      await time.increase(time.duration.days(690).add(BN(1)));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('100'));
    });
  });

  describe('#withdraw', async function () {
    const amount = BN('100');

    let snapshot_;
    beforeEach(async function () {
      snapshot_ = await snapshot();
      await this.tokenSale.launchSale({ from: controller });
    });

    afterEach(async function () {
      await snapshot_.restore();
    });

    it('recipient address cannot be null', async function () {
      await this.tokenSale.addBalance(account, amount, { from: controller });
      await expectRevert(
        this.tokenSale.withdraw(ZERO_ADDRESS, amount),
        'ScheduledTokenSale: Recipient address cannot be null',
      );
    });

    it('amount must be greater than zero', async function () {
      await this.tokenSale.addBalance(account, amount, { from: controller });
      await expectRevert(
        this.tokenSale.withdraw(account, 0),
        'ScheduledTokenSale: Withdraw amount must be greater than zero',
      );
    });

    it.skip('unlock schedule not started yet', async function () {
      await this.tokenSale.addBalance(account, amount, { from: controller });
      await expectRevert(
        this.tokenSale.withdraw(account, 0),
        'ScheduledTokenSale: Unlock schedule not started yet',
      );
    });

    it('20% withdraw after 60 days', async function () {
      const withdrawAmount = BN('20');

      await this.tokenSale.addBalance(account, amount, { from: controller });

      await time.increase(time.duration.minutes(1));
      await expectRevert(
        this.tokenSale.withdraw(account, withdrawAmount, { from: account }),
        'ScheduledTokenSale: Amount to withdraw is greater than unlocked amount',
      );

      // Withdraw all unlocked funds after 60 days
      await time.increase(time.duration.days(60).add(BN(1)));
      await this.tokenSale.withdraw(account, withdrawAmount, { from: account });
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(BN('80'));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('0'));

      // Check available funds after next phase
      await time.increase(time.duration.days(180).add(BN(1)));
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(BN('80'));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('30'));
    });

    it('90% withdraw after 600 days', async function () {
      const withdrawAmount = BN('90');

      await this.tokenSale.addBalance(account, amount, { from: controller });

      // Withdraw all unlocked funds after 600 days
      await time.increase(time.duration.days(600).add(BN(1)));
      await this.tokenSale.withdraw(account, withdrawAmount, { from: account });
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(BN('10'));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('0'));

      // Check available funds after next phase
      await time.increase(time.duration.days(90).add(BN(1)));
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(BN('10'));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('10'));
    });

    it('100% withdraw after 690 days', async function () {
      const withdrawAmount = BN('100');

      await this.tokenSale.addBalance(account, amount, { from: controller });

      // Withdraw all unlocked funds after 690 days
      await time.increase(time.duration.days(690).add(BN(1)));
      await this.tokenSale.withdraw(account, withdrawAmount, { from: account });
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(BN('0'));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('0'));

      // Check available funds after next phase
      await time.increase(time.duration.days(1));
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(BN('0'));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(BN('0'));

      await expectRevert(
        this.tokenSale.withdraw(account, withdrawAmount, { from: account }),
        'ScheduledTokenSale: Amount to withdraw is greater than unlocked amount',
      );
    });
  });
});
