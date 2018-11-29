var SmartProtectionPolicyBeta = artifacts.require("../contracts/SmartProtectionPolicyBeta.sol");


module.exports = function(deployer, network, accounts) {
   	deployer.deploy(
        SmartProtectionPolicyBeta
    );
};
