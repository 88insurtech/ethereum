web3.personal.unlockAccount("0xc93c6ebdf802061d88b1d26e93f9779fc5f25ac6", "deltasp5k", 15000);

a = "0xc93c6ebdf802061d88b1d26e93f9779fc5f25ac6"//eth.accounts[2]

web3.eth.defaultAccount = a;

console.log("Account selected", a);

//var simpleFactory = web3.eth.contract([{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"vi$
//var simpleFactory = web3.eth.contract([{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"vi$
var simpleFactory = web3.eth.contract([{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view$

//var simpleSource = 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }contract Toke$
//var simpleSource = '[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"functi$
var simpleSource = '';

//var simpleCompiled = "0x"+"60606040526012600255341561001457600080fd5b60405161099b38038061099b8339810160405280805191906020018051820191906020018051600254600a0a85$
//var simpleCompiled = "0x"+"60606040526012600260006101000a81548160ff021916908360ff160217905550600060035534156200003157600080fd5b60405162001460380380620014608339$
var simpleCompiled = "0x"+"60606040526012600260006101000a81548160ff021916908360ff160217905550600060035534156200003157600080fd5b604051620013d5380380620013d5833981$

//web3.eth.compile.solidity(simpleSource);
//var simpleRoot = Object.keys(simpleCompiled)[0];

//var simpleContract = web3.eth.contract(simpleCompiled[simpleRoot].info.abiDefinition);

var simple = simpleFactory.new(100000000, 'ZCO', 'ZCO', {from:web3.eth.defaultAccount, data: simpleCompiled, gas: 3000000}, function(e, contract) {
        if (e) {
                console.log("err creating contract", e);
        } else {
                if (!contract.address) {
                        console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");
                } else {
                        console.log("Contract mined! Address: " + contract.address);
                        console.log(contract);
                }
        }
});


