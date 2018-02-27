var Seguro = artifacts.require("../contracts/Seguro.sol");

module.exports = function(deployer, network, accounts) {
  //address benef, uint256 numeroApolice, uint256 valorDoBemSegurado, uint256 valorDoBem, uint256 valorDaFranquia  
  deployer.deploy(Seguro, 
                  "0x0046c25c0A5aFAa1839f58f10d792da4e9b73F9B",
                  1234,
                  1000.00,
                  5000.00,
                  700.00
                );
  //deployer.deploy(seguro, {gas: 4612388, from: "0x00E9ecF2C0e35Ba6392e29D0C82fFBe33B3B1C6C"});

};
