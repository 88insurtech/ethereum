
/**
 * 
 * usage 
 * 
 * on truffle develop
 * exec ./resources/SmartProtectionPolicyBeta.js
 * 
 * out of truffle
 * truffle exec ./resources/SmartProtectionPolicyBeta.js 
 * 
 */

const artifacts = require('../build/contracts/SmartProtectionPolicyBeta.json')
const contract = require('truffle-contract')
const contratoRSK = contract(artifacts);

module.exports = function(callback) {

    //console.log(web);

    contratoRSK.setProvider(web3.currentProvider);
    
    contratoRSK.deployed()
    .then(function(instance) {
      console.log(instance.address)
    })
    .catch(function(error) {
      console.error(error)
    });

    console.log('test');
    console.log(contratoRSK);

    web3.personal.importRawKey('0xce32b3ea4182f2d213ddba58318fc379d206ea9ab4f3d78623b4b84e5b9065b0', 'trinity');

    web3.eth.accounts.privateKeyToAccount('0xce32b3ea4182f2d213ddba58318fc379d206ea9ab4f3d78623b4b84e5b9065b0');


/*

SmartProtectionPolicyBeta.deployed().then(function(contract){ contratoRSK = contract; });

//Set comission
contratoRSK.setFeeCommissionsPercent.call().then(console.log);

//Set donation
contratoRSK.sendDonationAmount.call(accounts[0]).then(console.log);
*/

}





