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

    it("should not accept 1 (Agent) invalid param calling setFeeCommissionsPercent", async () => {
        // Test invalid Agent
        try {
            await globalContract.setFeeCommissionsPercent(8, 0);
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
            assert.equal(await globalContract.getCommissionFeeAgentPercent(), 1);
            assert.equal(await globalContract.getCommissionFeeBrokerPercent(), 1);
            assert.equal(await globalContract.getCommissionFeePercent(), 2);
        }
    });

    it("should not accept 1 (Broker) invalid param calling setFeeCommissionsPercent", async () => {
        // Test invalid broker
        try {
            await globalContract.setFeeCommissionsPercent(0, 8);
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
            assert.equal(await globalContract.getCommissionFeeAgentPercent(), 1);
            assert.equal(await globalContract.getCommissionFeeBrokerPercent(), 1);
            assert.equal(await globalContract.getCommissionFeePercent(), 2);
        }
    });

    it("should not accept 2 invalid params calling setFeeCommissionsPercent", async () => {
        try {
            await globalContract.setFeeCommissionsPercent(0, 0);
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
            assert.equal(await globalContract.getCommissionFeeAgentPercent(), 1);
            assert.equal(await globalContract.getCommissionFeeBrokerPercent(), 1);
            assert.equal(await globalContract.getCommissionFeePercent(), 2);
        }
    });

    it("should works fine passing 2 valid params calling setFeeCommissionsPercent", async () => {
        let agentPercent = 7;
        let brokerPercent = 8;

        // Check initial status
        assert.equal(await globalContract.getCommissionFeeAgentPercent(), 1);
        assert.equal(await globalContract.getCommissionFeeBrokerPercent(), 1);
        assert.equal(await globalContract.getCommissionFeePercent(), 2);

        await globalContract.setFeeCommissionsPercent(brokerPercent, agentPercent);
        
        assert.equal(await globalContract.getCommissionFeeAgentPercent(), agentPercent);
        assert.equal(await globalContract.getCommissionFeeBrokerPercent(), brokerPercent);
        assert.equal(await globalContract.getCommissionFeePercent(), (brokerPercent + agentPercent));
    });

    it("should change donationsPercent calling changeDonationValue", async () => {
        let value = 7;
        assert.equal(await globalContract.donationsPercent(), 2);
        await globalContract.changeDonationValue(value);
        assert.equal(await globalContract.donationsPercent(), 7);
    });

    it("should not change donationsPercent from another account", async () => {
        try {
            assert.equal(await globalContract.donationsPercent(), 2);
            await globalContract.changeDonationValue(7, {from: thirdAccount});
            assert.isOk(false);
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
            assert.equal(await globalContract.donationsPercent(), 2);
        }
    });

    it("should call splitCommissionsWithExternalMoney method with no expected erros", async () => {
        let agentPercent = 7;
        let brokerPercent = 8; 
        let amount = web3.toWei(1, "shannon"); // 1gwei // 1000000000
        
        let expectedAgentFeeValue = amount * (agentPercent / 100);
        let expectedBrokerFeeValue = amount * (brokerPercent / 100);
        let expectedFeeValue = (expectedAgentFeeValue + expectedBrokerFeeValue);

        await globalContract.setFeeCommissionsPercent(brokerPercent, agentPercent);
        await globalContract.splitCommissionsWithExternalMoney({value: amount});

        let agentFeeValue = await globalContract.getCommissionFeeAgentValue();
        let brokerFeeValue = await globalContract.getCommissionFeeBrokerValue();
        let feeValue = await globalContract.getCommissionFeeValue();

        assert.equal(agentFeeValue.toNumber(), expectedAgentFeeValue);
        assert.equal(brokerFeeValue.toNumber(), expectedBrokerFeeValue);
        assert.equal(feeValue.toNumber(), expectedFeeValue);
    });

    it("should not accept calls on splitCommissionsWithExternalMoney by another account", async () => {
        try {
            await globalContract.setFeeCommissionsPercent(8, 8);
            // must throw error
            await globalContract.splitCommissionsWithExternalMoney({
                from: secondAccount,
                value: web3.toWei(2, "ether")
            });
            assert.isOk(false, "This method should not be called.");
        } catch (error) {
            assert.isOk(/revert/.test(error.message));
            assert.equal(await globalContract.getCommissionFeeAgentValue(), 0);
            assert.equal(await globalContract.getCommissionFeeBrokerValue(), 0);
            assert.equal(await globalContract.getCommissionFeeValue(), 0);
        }
    });

    it("should send fee to Agent calling sendCommissionSplitedAgent with Fee", async () => {
        try {
            let agentCommissionPercent = 100; //8%
            let amount = web3.toWei(2, "shannon");

            globalContract.agent = secondAccount;
            assert.isFalse(await globalContract.agentPayed());

            let agentInitialBalance = await web3.eth.getBalance(secondAccount);
            
            await globalContract.setFeeCommissionsPercent(3, agentCommissionPercent);
            await globalContract.splitCommissionsWithExternalMoney({value: amount});
            // sendCommissionSplitedAgent may trows an exception
            await globalContract.sendCommissionSplitedAgent();

            let commission = amount * (agentCommissionPercent/100);
            let expectedAccountBalance = agentInitialBalance.toNumber() + commission;
            let currentAgentBalance = await web3.eth.getBalance(secondAccount);
            
            // this doesn't works on ganache, only on geth or parity
            /*assert.equal(
                currentAgentBalance.toNumber(),
                expectedAccountBalance,
                "Something went wrong with transfer"
            );*/
            assert.isTrue(await globalContract.agentPayed());

        } catch (error) {
            assert.isOk(false, error.message);
        }
    });

    it("should send fee to the broker calling sendCommissionSplitedBroker", async () => {
        try {
            let brokerCommissionPercent = 100; //8%
            let amount = web3.toWei(3, "shannon");

            globalContract.broker = thirdAccount;
            assert.isFalse(await globalContract.brokerPayed());

            let brokerInitialBalance = await web3.eth.getBalance(thirdAccount);
            
            await globalContract.setFeeCommissionsPercent(brokerCommissionPercent, 4);
            await globalContract.splitCommissionsWithExternalMoney({value: amount});
            // sendCommissionSplitedBroker may trows an exception
            await globalContract.sendCommissionSplitedBroker();

            let commission = amount * (brokerCommissionPercent/100);
            let expectedAccountBalance = brokerInitialBalance.toNumber() + commission;
            let currentBrokerBalance = await web3.eth.getBalance(thirdAccount);
            
            // this doesn't works on ganache, only on geth or parity
            /*assert.equal(
                expectedAccountBalance,
                currentBrokerBalance.toNumber(),
                "Something went wrong with transfer"
            );*/
            assert.isTrue(await globalContract.brokerPayed());

        } catch (error) {
            assert.isOk(false, error.message);
        }
    });
});
