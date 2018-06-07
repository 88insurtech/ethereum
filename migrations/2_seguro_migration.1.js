var Seguro = artifacts.require("../contracts/Seguro.sol");

module.exports = function(deployer, network, accounts) {
	//address benef, uint256 numeroApolice, uint256 valorDoBemSegurado, uint256 valorDoBem, uint256 valorDaFranquia  
  	deployer.deploy(
        Seguro,
  		accounts[1],
  		1234,
        1000.00,
        5000.00,
        700.00
    );
};
