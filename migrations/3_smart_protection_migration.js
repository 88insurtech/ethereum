var SmartProtection = artifacts.require("../contracts/SmartProtectionPolicy.sol");

module.exports = function(deployer, network, accounts) {
    // address acustomeraddress, 
    // string acustomerName, 
    // uint256 apolicynumber, 
    // uint256 avalueOfProperty, 
    // uint256 apremium, 
    // uint256 afranchise, 
    // string ainsuredItem
  	deployer.deploy(
        SmartProtection,
  		accounts[1],
        "Alex Silva",
        88,  
        2500.00,
        300.00,
        70.00,
        "Galaxy S7"
    );
};
