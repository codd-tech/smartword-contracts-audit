const { expect } = require('chai');
const { BN, expectEvent, constants } = require('@openzeppelin/test-helpers');
const { ZERO_ADDRESS } = constants;

const TOTAL_SWGT_SUPPLY = new BN('100000000000000000');
const Token = artifacts.require('SWGT');

contract('SWGT', function ([owner, account]) {
  beforeEach(async function () {
    this.token = await Token.new();
  });

  describe('test token initialization', function () {
    it('token name', async function () {
      expect(await this.token.name()).to.be.equal('SmartWorld Global Token');
    });
    it('token symbol', async function () {
      expect(await this.token.symbol()).to.be.equal('SWGT');
    });
    it('token decimals', async function () {
      expect(await this.token.decimals()).to.be.bignumber.equal(new BN('8'));
    });
    it('totalSupply is set', async function () {
      expect(await this.token.totalSupply()).to.be.bignumber.equal(new BN(TOTAL_SWGT_SUPPLY));
    });
    it('balanceOf returns totalSupply', async function () {
      expect(await this.token.balanceOf(owner))
        .to.be.bignumber.equal(new BN(TOTAL_SWGT_SUPPLY));
      expect(await this.token.balanceOf(account))
        .to.be.bignumber.equal(new BN('0'));
    });
    it('allowance returns zeros', async function () {
      expect(await this.token.allowance(owner, account))
        .to.be.bignumber.equal(new BN('0'));
      expect(await this.token.allowance(account, owner))
        .to.be.bignumber.equal(new BN('0'));
    });
  });

  describe('test token burning', function () {
    it('burn some tokens', async function () {
      const initialTotalSupply = new BN(await this.token.totalSupply());
      const amountToBurn = new BN('4');

      await this.token.burn(amountToBurn);
      expect(await this.token.totalSupply()).to.be.bignumber.equal(initialTotalSupply.sub(amountToBurn));
      expect(await this.token.balanceOf(owner)).to.be.bignumber.equal(initialTotalSupply.sub(amountToBurn));
    });
  });

  describe('test burnFrom', function () {
    it('burn some shared tokens', async function () {
      const initialTotalSupply = new BN(await this.token.totalSupply());

      await this.token.approve(account, initialTotalSupply);
      const { logs } = await this.token.burnFrom(
        owner,
        initialTotalSupply,
        { from: account },
      );
      expectEvent.inLogs(
        logs, 'Transfer', {
          from: owner,
          to: ZERO_ADDRESS,
          value: initialTotalSupply,
        },
      );
      expectEvent.inLogs(
        logs, 'Approval', {
          owner: owner,
          spender: account,
          value: new BN('0'),
        },
      );
      expect(await this.token.balanceOf(owner)).to.be.bignumber.equal(new BN('0'));
      expect(await this.token.allowance(owner, account)).to.be.bignumber.equal(new BN('0'));
    });
  });
});
