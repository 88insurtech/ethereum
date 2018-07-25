var SmartProtectionPolicy = artifacts.require("SmartProtectionPolicy");

contract('SmartProtectionPolicy', function(accounts) {

    let globalContract;
    const [firstAccount, secondAccount, thirdAccount] = accounts;

    // Every scenario has a contract for tests prepared
    beforeEach(async () => {
        globalContract = await SmartProtectionPolicy.new(
            thirdAccount,
            "Alex Silva",
            88,  
            2500.00,
            300.00,
            70.00,
            "Samsung Galaxy S7",
        );
    });

    it("should instantiate the contract with no errors", async () => {
        let contract;
        try {
            contract = await SmartProtectionPolicy.new(
                thirdAccount,
                "Alex Silva",
                88,  
                2500.00,
                300.00,
                70.00,
                "Samsung Galaxy S7"
            );
        } catch (error) {
            assert.isOk(false);
        }
        assert.isTrue(/0x[0-9A-Fa-f]{40}/.test(contract.address));
        assert.isTrue(/0x[0-9A-Fa-f]{64}/.test(contract.transactionHash));
    });

    it("should not accept instantiate when missing params", async () => {
        let paramsArray = [
            ["Alex Silva", 88, 2500.00, 300.00, 70.00, "Samsung Galaxy S7"],
            [thirdAccount, 88, 2500.00, 300.00, 70.00, "Samsung Galaxy S7"],
            [70.00, "Samsung Galaxy S7"],
            [thirdAccount, "Alex Silva", 88, 2500.00, 300.00, "Samsung Galaxy S7"],
            [thirdAccount, "Alex Silva"]
        ];

        for (let i = 0; i < paramsArray.length; i++) {
            try {
                let contract = await SmartProtectionPolicy.new(...paramsArray[i]);
                assert.isOk(false);
            } catch (error) {
                assert.isOk(/constructor expected \d arguments, received \d/.test(error.message));
            }   
        }
    });

    // It tests the function calls only, not the result. It's strongly recommended tests the results
    // To do it, it's necessary to have comissionFeePercent attribute public or has a Get method
    it("should not accept _broker OR _agent be 0 calling setFeeComissionsPercent", async () => {
        // both invalid
        try {
            await globalContract.setFeeComissionsPercent(0, 0);
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
        }
        // one (_blocker) valid
        try {
            await globalContract.setFeeComissionsPercent(8, 0);
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
        }
        // one (_agent) valid
        try {
            await globalContract.setFeeComissionsPercent(8, 0);
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
        }
    });

    // It tests the function calls only, not the result. It's strongly recommended tests the results
    // To do it, it's necessary to have comissionFeePercent attribute public or has a Get method
    it("should works fine passing 2 valid params calling setFeeComissionsPercent", async () => {
        try {
            let result = await globalContract.setFeeComissionsPercent(8, 8);
            assert.isTrue(/0x[0-9A-Fa-f]{64}/.test(result.tx));
        } catch (error) {
            assert.isOk(false);
        }
    });

    // It tests the function calls only, not the result. It's strongly recommended tests the results
    // To do it, it's necessary to have comissionFeeValue, comissionFeeAgentValue and 
    // comissionFeeBrokerValue attribute public or has a Get method
    it("should call splitComissions method with no erros", async () => {
        try {
            await globalContract.setFeeComissionsPercent(8, 8);
            await globalContract.splitComissions({value: web3.toWei(1, "ether")});
            assert.isOk(true);
        } catch (error) {
            assert.isOk(false);
        }
    });

    // It tests the function calls only, not the result. It's strongly recommended tests the results
    // To do it, it's necessary to have comissionFeeValue, comissionFeeAgentValue and 
    // comissionFeeBrokerValue attribute public or has a Get method
    it("should not accept calls on splitComissions by another account", async () => {
        try {
            await globalContract.setFeeComissionsPercent(8, 8);
            await globalContract.splitComissions({from: secondAccount, value: web3.toWei(1, "ether")});
            // must throw error
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
        }
    });

    it("should send fee to Agent calling sendComissionSplitedAgent", async () => {
        try {
            let agentComissionPercent = 8; //8%
            let amount = web3.toWei(1, "ether");

            globalContract.agent = secondAccount;
            assert.isFalse(await globalContract.agentPayed());

            let agentInitialBalance = await web3.eth.getBalance(secondAccount);
            
            await globalContract.setFeeComissionsPercent(3, agentComissionPercent);
            await globalContract.splitComissions({value: amount});
            await globalContract.sendComissionSplitedAgent();
            
            let comission = amount * (agentComissionPercent/100);
            let expectedAccountBalance = agentInitialBalance.toNumber() + comission;
            let currentAgentBalance = await web3.eth.getBalance(secondAccount);
            
            assert.equal(expectedAccountBalance, currentAgentBalance.toNumber());
            assert.isTrue(await globalContract.agentPayed());

        } catch (error) {
            assert.isOk(false);
        }
    });

    it("should send fee to the broker calling sendComissionSplitedBroker", async () => {
        try {
            let brokerComissionPercent = 8; //8%
            let amount = web3.toWei(1, "ether");

            globalContract.broker = thirdAccount;
            assert.isFalse(await globalContract.brokerPayed());

            let brokerInitialBalance = await web3.eth.getBalance(thirdAccount);
            
            await globalContract.setFeeComissionsPercent(brokerComissionPercent, 4);
            await globalContract.splitComissions({value: amount});
            await globalContract.sendComissionSplitedAgent();

            let comission = amount * (brokerComissionPercent/100);
            let expectedAccountBalance = brokerInitialBalance.toNumber() + comission;
            let currentBrokerBalance = await web3.eth.getBalance(secondAccount);
            
            assert.equal(expectedAccountBalance, currentBrokerBalance.toNumber());
            assert.isTrue(await globalContract.brokerPayed());

        } catch (error) {
            assert.isOk(false);
        }
    });
});
