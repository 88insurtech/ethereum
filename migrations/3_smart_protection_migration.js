var SmartProtection = artifacts.require("../contracts/SmartProtectionPolicy.sol");

module.exports = function(deployer, network, accounts) {
    // address _customeraddress, 
    // string _customerName, 
    // uint256 _policynumber, 
    // uint256 _valueOfProperty, 
    // uint256 _premium, 
    // uint256 _franchise, 
    // string _insuredItem,
    // address _agent,
    // address _broker,
    // address _donationsSocialDestiny
  	deployer.deploy(
        SmartProtection,
  		accounts[1],
        "Alex Silva",
        88,  
        2500.00,
        300.00,
        70.00,
        "Galaxy S7",
        accounts[2],
        accounts[3],
        accounts[4]
    );
};
