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
                "Samsung Galaxy S7",
                { from: secondAccount }
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

    it("should not accept 1 (Agent) invalid param calling setFeeComissionsPercent", async () => {
        // Test invalid Agent
        try {
            await globalContract.setFeeComissionsPercent(8, 0);
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
            assert.equal(await globalContract.getComissionFeeAgentPercent(), 1);
            assert.equal(await globalContract.getComissionFeeBrokerPercent(), 1);
            assert.equal(await globalContract.getComissionFeePercent(), 2);
        }
    });

    it("should not accept 1 (Broker) invalid param calling setFeeComissionsPercent", async () => {
        // Test invalid broker
        try {
            await globalContract.setFeeComissionsPercent(0, 8);
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
            assert.equal(await globalContract.getComissionFeeAgentPercent(), 1);
            assert.equal(await globalContract.getComissionFeeBrokerPercent(), 1);
            assert.equal(await globalContract.getComissionFeePercent(), 2);
        }
    });

    it("should not accept 2 invalid params calling setFeeComissionsPercent", async () => {
        try {
            await globalContract.setFeeComissionsPercent(0, 0);
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
            assert.equal(await globalContract.getComissionFeeAgentPercent(), 1);
            assert.equal(await globalContract.getComissionFeeBrokerPercent(), 1);
            assert.equal(await globalContract.getComissionFeePercent(), 2);
        }
    });

    it("should works fine passing 2 valid params calling setFeeComissionsPercent", async () => {
        let agentPercent = 7;
        let brokerPercent = 8;

        // Check initial status
        assert.equal(await globalContract.getComissionFeeAgentPercent(), 1);
        assert.equal(await globalContract.getComissionFeeBrokerPercent(), 1);
        assert.equal(await globalContract.getComissionFeePercent(), 2);

        await globalContract.setFeeComissionsPercent(brokerPercent, agentPercent);
        
        assert.equal(await globalContract.getComissionFeeAgentPercent(), agentPercent);
        assert.equal(await globalContract.getComissionFeeBrokerPercent(), brokerPercent);
        assert.equal(await globalContract.getComissionFeePercent(), (brokerPercent + agentPercent));
    });

    it("should call splitComissions method with no expected erros", async () => {
        let agentPercent = 7;
        let brokerPercent = 8; 
        let amount = web3.toWei(1, "shannon"); // 1gwei // 1000000000
        
        let expectedAgentFeeValue = amount * (agentPercent / 100);
        let expectedBrokerFeeValue = amount * (brokerPercent / 100);
        let expectedFeeValue = (expectedAgentFeeValue + expectedBrokerFeeValue);

        await globalContract.setFeeComissionsPercent(brokerPercent, agentPercent);
        await globalContract.splitComissions({value: amount});

        let agentFeeValue = await globalContract.getComissionFeeAgentValue();
        let brokerFeeValue = await globalContract.getComissionFeeBrokerValue();
        let feeValue = await globalContract.getComissionFeeValue();

        assert.equal(agentFeeValue.toNumber(), expectedAgentFeeValue);
        assert.equal(brokerFeeValue.toNumber(), expectedBrokerFeeValue);
        assert.equal(feeValue.toNumber(), expectedFeeValue);
    });

    it("should not accept calls on splitComissions by another account", async () => {
        try {
            await globalContract.setFeeComissionsPercent(8, 8);
            // must throw error
            await globalContract.splitComissions({
                from: secondAccount,
                value: web3.toWei(1, "ether")
            });
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
            assert.equal(await globalContract.getComissionFeeAgentValue(), 0);
            assert.equal(await globalContract.getComissionFeeBrokerValue(), 0);
            assert.equal(await globalContract.getComissionFeeValue(), 0);
        }
    });

    it("should send fee to Agent calling sendComissionSplitedAgent with Fee", async () => {
        try {
            let agentComissionPercent = 100; //8%
            let amount = web3.toWei(2, "shannon");

            globalContract.agent = secondAccount;
            assert.isFalse(await globalContract.agentPayed());

            let agentInitialBalance = await web3.eth.getBalance(secondAccount);
            
            await globalContract.setFeeComissionsPercent(3, agentComissionPercent);
            await globalContract.splitComissions({value: amount});
            await globalContract.sendComissionSplitedAgent();

            let comission = amount * (agentComissionPercent/100);
            let expectedAccountBalance = agentInitialBalance.toNumber() + comission;
            let currentAgentBalance = await web3.eth.getBalance(secondAccount);
            
            assert.equal(
                currentAgentBalance.toNumber(),
                expectedAccountBalance,
                "The transfer may been failed."
            );
            assert.isTrue(await globalContract.agentPayed());

        } catch (error) {
            console.log(error.message);
            assert.isOk(false);
        }
    });

    it("should send fee to the broker calling sendComissionSplitedBroker", async () => {
        try {
            let brokerComissionPercent = 100; //8%
            let amount = web3.toWei(3, "shannon");

            globalContract.broker = thirdAccount;
            assert.isFalse(await globalContract.brokerPayed());

            let brokerInitialBalance = await web3.eth.getBalance(thirdAccount);
            
            await globalContract.setFeeComissionsPercent(brokerComissionPercent, 4);
            await globalContract.splitComissions({value: amount});
            await globalContract.sendComissionSplitedAgent();

            let comission = amount * (brokerComissionPercent/100);
            let expectedAccountBalance = brokerInitialBalance.toNumber() + comission;
            let currentBrokerBalance = await web3.eth.getBalance(thirdAccount);
            
            assert.equal(
                expectedAccountBalance,
                currentBrokerBalance.toNumber(),
                "The transfer may been failed."
            );
            assert.isTrue(await globalContract.brokerPayed());

        } catch (error) {
            assert.isOk(false);
        }
    });
});
