const Flashswap = artifacts.require("Flashswap.sol");

module.exports = function(deployer, _network, [beneficiaryAddress, _]) {
    deployer.deploy(Flashswap);
};