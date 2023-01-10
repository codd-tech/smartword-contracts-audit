const { expect } = require('chai');
const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { ZERO_ADDRESS } = constants;

const SEED_TOKEN_SALE_CAP = new BN('2000000000000000');
const CONTROLLER_ROLE = web3.utils.soliditySha3('CONTROLLER_ROLE');

const Token = artifacts.require('SWGT');
const TokenLegacy = artifacts.require('LegacyToken');
const SeedTokenSale = artifacts.require('SeedTokenSale');

contract('SeedTokenSale', function ([owner, controller, account, other]) {
  beforeEach(async function () {
    this.token = await Token.new({ from: owner });
    this.tokenLegacy = await TokenLegacy.new({ from: owner });
    this.tokenSale = await SeedTokenSale.new(this.token.address, this.tokenLegacy.address, { from: owner });

    await this.tokenSale.grantRole(CONTROLLER_ROLE, controller, { from: owner });
    await this.token.transfer(this.tokenSale.address, SEED_TOKEN_SALE_CAP, { from: owner });
  });

  describe('initialization', async function () {
    it('should revert on token zero address', async function () {
      await expectRevert(
        SeedTokenSale.new(ZERO_ADDRESS, this.tokenLegacy.address, { from: owner }),
        'ScheduledTokenSale: New token address cannot be null',
      );
    });

    it('should revert on old token zero address', async function () {
      await expectRevert(
        SeedTokenSale.new(this.token.address, ZERO_ADDRESS, { from: owner }),
        'SeedTokenSale: Old token address cannot be null',
      );
    });
  });

  describe('convert()', async function () {
    beforeEach(async function () {
      await this.tokenLegacy.mint(owner, 100);
    });

    it('successfully converts tokens', async function () {
      await this.tokenLegacy.transfer(account, 20, { from: owner });
      await this.tokenLegacy.approve(this.tokenSale.address, 20, { from: account });
      await this.tokenSale.methods['convert(address,uint256)'](account, BN('20'), { from: account });

      expect(await this.tokenLegacy.balanceOf(account)).to.be.bignumber.equal(new BN('0'));
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(new BN('20'));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(new BN('0'));
    });

    it('successfully converts tokens for several accounts', async function () {
      await this.tokenLegacy.approve(this.tokenSale.address, 30, { from: owner });

      await this.tokenSale.methods['convert(address[],uint256[])']([account, other], [20, 10], { from: controller });

      expect(await this.tokenLegacy.balanceOf(account)).to.be.bignumber.equal(new BN('0'));
      expect(await this.tokenSale.balanceOf(account)).to.be.bignumber.equal(new BN('20'));
      expect(await this.tokenSale.unlockedOf(account)).to.be.bignumber.equal(new BN('0'));

      expect(await this.tokenLegacy.balanceOf(other)).to.be.bignumber.equal(new BN('0'));
      expect(await this.tokenSale.balanceOf(other)).to.be.bignumber.equal(new BN('10'));
      expect(await this.tokenSale.unlockedOf(owner)).to.be.bignumber.equal(new BN('0'));
    });

    it('should revert on insufficient SWG balance', async function () {
      await expectRevert(
        this.tokenSale.methods['convert(address,uint256)'](account, 20, { from: account }),
        'SeedTokenSale: Insufficient SWG balance',
      );
    });

    it('reject conversion of several accounts from non controller', async function () {
      await this.tokenLegacy.approve(this.tokenSale.address, 30, { from: owner });

      await expectRevert(
        this.tokenSale.methods['convert(address[],uint256[])']([account, other], [20, 10], { from: account }),
        'AccessControl: account ' + account.toLowerCase() + ' is missing role ' + CONTROLLER_ROLE,
      );
    });

    it('should revert on insufficient SWG balance', async function () {
      await expectRevert(
        this.tokenSale.methods['convert(address,uint256)'](account, 20, { from: account }),
        'SeedTokenSale: Insufficient SWG balance',
      );
    });

    it('should revert on insufficient SWG allowance', async function () {
      await this.tokenLegacy.transfer(account, 20, { from: owner });
      await this.tokenLegacy.approve(this.tokenSale.address, 19, { from: account });

      await expectRevert(
        this.tokenSale.methods['convert(address,uint256)'](account, 20, { from: account }),
        'SeedTokenSale: Not enough SWG allowance',
      );
    });
  });
});
