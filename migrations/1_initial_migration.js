const
  LegacyToken = artifacts.require('LegacyToken'),
  Token = artifacts.require('SWGT'),
  SeedTokenSale = artifacts.require('SeedTokenSale'),
  PrivateTokenSale = artifacts.require('PrivateTokenSale'),
  PublicTokenSale = artifacts.require('PublicTokenSale'),
  TeamTokenSale = artifacts.require('TeamTokenSale'),
  AdvisorsTokenSale = artifacts.require('AdvisorsTokenSale'),
  EcosystemTokenSale = artifacts.require('EcosystemTokenSale'),
  MarketingTokenSale = artifacts.require('MarketingTokenSale'),
  LiquidityTokenSale = artifacts.require('LiquidityTokenSale'),
  TreasuryTokenSale = artifacts.require('TreasuryTokenSale');

const transferTokens = async (token, contract, amount) => {
  const instance = await contract.deployed()

  console.log(`\n   Transferring SWGT to ${contract.contractName}`)
  console.log(`   ---------------------------------------------`)
  console.log(`   > From:   ${token.address}`)
  console.log(`   > To:     ${instance.address}`)
  console.log(`   > Amount: ${amount}\n`)

  return token.transfer(instance.address, amount)
}

module.exports = async function(deployer) {
  await deployer.deploy(LegacyToken)
  const legacyToken = await LegacyToken.deployed()

  // Replace with an actual legacy token address
  const legacyTokenAddress = legacyToken.address

  await deployer.deploy(Token)
  const token = await Token.deployed()

  await deployer.deploy(SeedTokenSale, token.address, legacyTokenAddress)
  await deployer.deploy(PrivateTokenSale, token.address)
  await deployer.deploy(PublicTokenSale, token.address)
  await deployer.deploy(TeamTokenSale, token.address)
  await deployer.deploy(AdvisorsTokenSale, token.address)
  await deployer.deploy(EcosystemTokenSale, token.address)
  await deployer.deploy(MarketingTokenSale, token.address)
  await deployer.deploy(LiquidityTokenSale, token.address)
  await deployer.deploy(TreasuryTokenSale, token.address)

  await transferTokens(token, SeedTokenSale, '2000000000000000');
  await transferTokens(token, PrivateTokenSale, '11000000000000000');
  await transferTokens(token, PublicTokenSale, '15000000000000000');
  await transferTokens(token, TeamTokenSale, '15000000000000000');
  await transferTokens(token, AdvisorsTokenSale, '5000000000000000');
  await transferTokens(token, EcosystemTokenSale, '25000000000000000');
  await transferTokens(token, MarketingTokenSale, '12000000000000000');
  await transferTokens(token, LiquidityTokenSale, '10000000000000000');
  await transferTokens(token, TreasuryTokenSale, '5000000000000000');
}
