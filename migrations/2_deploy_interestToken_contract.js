const interestToken = artifacts.require('InterestToken.sol');

module.exports = function (deployer) {
    deployer.deploy(interestToken);
  };