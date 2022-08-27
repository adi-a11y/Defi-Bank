const defiBank = artifacts.require('DefiBank.sol');

module.exports = function (deployer) {
    deployer.deploy(defiBank);
  };