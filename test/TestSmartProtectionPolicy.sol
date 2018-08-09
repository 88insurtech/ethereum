pragma solidity ^0.4.24;

import "../contracts/SmartProtectionPolicy.sol";
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

contract TestSmartProtectionPolicy {
    /* MNEMONIC 
     * Be sure to use this mnemonic in tests or change the account addresses
     * syrup patch buzz next slender margin chef casino timber that lawn rebuild
     */
    address firstAccount = 0xb5e47055a15E9fa2aB614E3997B6338eea8Ef55c;
    address secondAccount = 0x8c9A47b55334559cD1990D96ceE99f8A35E00dB9;
    address thirdAccount = 0xf13e234A4b084AF9e55BCcD85bd11bb8F3d6E854;
    address fourthAccount = 0x3b55d437a5c89EB5c8202fb2e332077F34E95Bf4;

    function testInstantiateContractWithNoErrors() public {
        // TODO need to check for throws or it will break the test
        SmartProtectionPolicy seguro = new SmartProtectionPolicy(
            thirdAccount,
            "Alex Silva",
            88,  
            2500.00,
            300.00,
            70.00,
            "Samsung Galaxy S7",
            secondAccount,
            fourthAccount,
            firstAccount
        );

        Assert.isNotZero(address(seguro), "Error when instantiate contract.");
        Assert.equal(uint(seguro.getPolicyStatus()), uint(0), "Wrong initial status.");
    }
}