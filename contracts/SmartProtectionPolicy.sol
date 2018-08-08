pragma solidity ^0.4.24;

/** v0.1.0
 * Author(s): Alex Braz, Alex Silva & Daniel Miranda

 * Contract in Alpha. 

 * # 88 Insurance Contract #
 * SmartProtectionPolicy
 * Involves four 'insurtech' -- 'agent', 'broker', 'customer'
 * Holds Ether from 'sender' to be transferred to 'customer' where a claim occur.
 * Ether in contract is transferred to 'agent' and 'broker' when a new Insurance is contracted by `customer`.
 * Contract has `1 year` validity
 * Some value `dinamically` is transferred to a Ether account for an Social impact.
 **/
contract SmartProtectionPolicy {

    enum StatusPolicy { ACTIVE, FINISHED, INACTIVE, CONTAIN_CLAIM }

    StatusPolicy status;
    StatusPolicy constant defaultStatus = StatusPolicy.ACTIVE;
    Policy policy;
    address owner; // 88 Ethereum Account

    struct Policy {
        /** Contains the policy start date and time **/
        uint256 startPolicyTime;        
        uint256 policyNumber;
        uint256 valueOfProperty;
        string insuredItem;
        string customerName;
        
        /** The address of the customer created by mobile aplication **/
        address customer;
        
        uint256 premium;
        uint256 deductablePaymentValue;
        uint256 contractDuration;
        
        uint256 policyBalanceValue;
    }

    /** The address of the agent, the dealer **/
    address agent;
    bool agentPayed = false;

    /** The address of the broker **/
    address broker;  
    bool brokerPayed = false;

    /** This event changes the Apolice Status, and is called when something very important occurs **/
    event ChangeStatus(StatusPolicy status, uint256 eventValue);

    /** This event changes the Apolice Status, and is called when something very important occurs **/
    event CommissionPayed(address _address, uint256 eventValue);

    /**
     * The Claim object, one contract can be zero or n claims
     * ID is the unique identifier comes from internal system
     */
    struct Claim {
        uint id;
        uint internalId;
        uint256 claimValue;
        uint dateTime;
        bool idReceived;
        bool videoReceived;
        bool deductablePayed;
        bool imeiBlocked;
        bool policeNoticeReport;
    }

    /** One contract can have zero or n claims **/
    Claim[] claims;

    /** The percent of fee **/
    uint256 commissionFeePercent = 2;
    uint256 commissionFeeValue = 0x0;

    /** The percent (%) of fee to the Broker **/
    uint256 commissionFeeBrokerPercent = 1;

    /** The percent (%) of fee to the agent **/
    uint256 commissionFeeAgentPercent = 1;

    /** The commission values for stakeholders **/
    uint256 commissionFeeBrokerValue = 0x0; /** The value of fee in Ether to be sended to Broker **/
    uint256 commissionFeeAgentValue = 0x0; /** The value of fee in Ether to be sended to Agent **/

    /**
     *
     * Some of the contract amount have to be donation
     * The default percent value is 2%
     * The owner can modify it calling changeDonationValue method
     *
     * When the contract is expired, the owner can call sendDonationAmount method
     * That method (sendDonationAmount) will send to an address the correspondent value in Ethers
     *
     *
     */
    uint256 donationsPercent = 2;
    bool donated = false;
    uint256 donationValue;
    address donationsSocialDestiny;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You're not the owner.");
        _;
    }

    modifier notDonatedYet() {
        if (donated) {
            revert("Donation already done.");
        }
        _;
    }
    
    constructor (
        address acustomeraddress, 
        string acustomerName, 
        uint256 apolicynumber, 
        uint256 avalueOfProperty, 
        uint256 apremium, 
        uint256 afranchise, 
        string ainsuredItem) public {

        owner = msg.sender;

        require(apolicynumber != 0x0);
        require(avalueOfProperty != 0x0);
        require(apremium != 0x0);
        require(afranchise != 0x0);
        
        bytes memory tempEmptyStringTest = bytes(ainsuredItem); // Uses memory
        if (tempEmptyStringTest.length == 0) {
            // emptyStringTest is an empty string
            ainsuredItem = "The value of Insured Item is not provided";
        }

        policy = Policy({
            startPolicyTime : now,
            policyNumber : apolicynumber,
            valueOfProperty : avalueOfProperty,
            insuredItem : ainsuredItem,
            customerName : acustomerName,
            customer : acustomeraddress,
            premium : apremium,
            deductablePaymentValue : afranchise,
            contractDuration : 365 days,
            policyBalanceValue : apremium
        });

        emit ChangeStatus(defaultStatus, apremium);
    }

    function notZero(uint8 _value) private pure {
        require (_value != 0x0);
    }
    
    /**
     * 
     */
    function setFeeCommissionsPercent(uint8 _broker, uint8 _agent) public onlyOwner returns (bool) {
        /**Avoid zero fee commission **/
        notZero(_broker);
        notZero(_agent);
        
        /** The percent (%) of fee to the Broker **/
        commissionFeeBrokerPercent = _broker;

        /** The percent (%) of fee to the agent **/
        commissionFeeAgentPercent = _agent; 
        
        /** The percent of fee **/
        commissionFeePercent = _broker + _agent;
        
        return true;
    }

    /**
     * This method change the percent of donation when the contract is expired
     */
    function changeDonationValue(uint8 percentOfDonation) public onlyOwner {
        donationsPercent = percentOfDonation;
    }

    /**
     * This method sends the amount to the donation destiny account
     * First you need to call changeDonationValue, 
     * you can call this method once
     */
    function sendDonationAmount(address donationsDestiny) public onlyOwner notDonatedYet {
        require(donationsDestiny != 0x0);
        require(address(this).balance != 0x0);
        
        donationValue = address(this).balance * donationsPercent;
        donationValue = donationValue / 100;
        donationsSocialDestiny.transfer(donationValue);
        donated = true;
    }

    /**
     * Needs to be called after set Commissions Percent
     * send a percent of Ether received to:
     * Agent
     * Broker
     */
    function splitCommissionsWithExternalMoney() public onlyOwner payable returns(bool) {
        return calculateCommissions(msg.value);
    }

    /**
     * Only use thie method in phase 2
     */
    function splitCommissionsWithContractMoney() public onlyOwner payable returns(bool) {
        return calculateCommissions(address(this).balance);
    }

    /**
     * This method calculates commissions, if we are using contract balance,  
     */
    function calculateCommissions(uint256 originFunds) internal onlyOwner returns (bool) {
        uint totalCommissionPayable = 0;

        /**
         * requires called only if values are not calculated yet
         */
        require((commissionFeeAgentValue == 0x0) && (commissionFeeBrokerValue == 0x0));

        /**
         * Calculates and send a percent of ether to Agent
         */
        if (commissionFeeAgentPercent != 0x0 ) {
            commissionFeeAgentValue = originFunds * commissionFeeAgentPercent;
            commissionFeeAgentValue = commissionFeeAgentValue / 100;
            totalCommissionPayable += commissionFeeAgentValue;
        }

        /**
         * Calculates and send a percent of ether to Broker
         */
        if (commissionFeeBrokerPercent != 0x0 ) {
            commissionFeeBrokerValue = originFunds * commissionFeeBrokerPercent;
            commissionFeeBrokerValue = commissionFeeBrokerValue / 100;
            totalCommissionPayable += commissionFeeBrokerValue;
        }

        /**
         * Sets only one time, commission fee value per execution 
         */
        commissionFeeValue = totalCommissionPayable;

        return totalCommissionPayable > 0x0;
    }

    /**
     * Needs to be called after commission split
     *
     */
    function sendCommissionSplitedAgent() public onlyOwner returns (bool) {
        if (commissionFeeAgentValue != 0x0) {
            agent.transfer(commissionFeeAgentValue);
            agentPayed = true;
        }
        
        return true;
    }

    /**
     * Needs to be called after commission split
     *
     */
    function sendCommissionSplitedBroker() public onlyOwner returns (bool) {
        if (commissionFeeBrokerValue != 0x0) {
            broker.transfer(commissionFeeBrokerValue);
            brokerPayed = true;
        }
        
        return true;
    }
    
    /**
     * Creates a new claim
     * First Notice of Loss
     */
    function FNOL(uint _internalId, uint _value) public onlyOwner returns (uint256) {
        /**
         * The claim value needs to be less than policy balance
         */
        require(policy.policyBalanceValue - _value >= 0x0);
        
        /**
         * Add the claim to the claim list
         *
         */
        uint _id = claims.push(Claim({
            internalId: _internalId,
            id: _id,
            claimValue: _value,
            dateTime: now,
            idReceived: false,
            videoReceived: false,
            deductablePayed: false,
            imeiBlocked: false,
            policeNoticeReport: false
        }));

        /**
         * Set the new balance of policy
         */
        policy.policyBalanceValue -= _value;

        /**
         * Set policy status CONTAIN_CLAIN only if policy status is different
         */
        if (status != StatusPolicy.CONTAIN_CLAIM) {
            status = StatusPolicy.CONTAIN_CLAIM;
            emit ChangeStatus(status, _value);
            log3(
                "New Claim",
                bytes32(msg.sender),
                bytes32(_value),
                bytes32(_id)
            );
        }
 
        return _id;
    }
 
    /*
     * The function suicide nao eh mais utilizada
     * EIP 6 - Recomends selfdestruct
     */
    function finalizePolicy() public onlyOwner {
        status = StatusPolicy.INACTIVE;
        emit ChangeStatus(status, policy.policyBalanceValue);
        selfdestruct(owner);
    }

    /**
     * This method
     */
    function setClaimDocumentationWorkFlow(
        uint _internalId, 
        bool _idReceived, 
        bool _videoReceived, 
        bool _deductablePayed, 
        bool _imeiBlock, 
        bool _policeNoticeReport) public onlyOwner {

        require(_internalId != 0x0);

        uint8 x = 0;
        while (x < claims.length) {
            if(claims[x].internalId == _internalId){
                claims[x].idReceived = _idReceived;
                claims[x].videoReceived = _videoReceived;
                claims[x].deductablePayed = _deductablePayed;
                claims[x].imeiBlocked = _imeiBlock;
                claims[x].policeNoticeReport = _policeNoticeReport;
                return;
            }
            x++;
        }
    }

    /**
     * This method sends an value in Ether to customer address
     */
    function payPremmiumToCustomer(uint _internalId, uint value) public onlyOwner {
        require(_internalId != 0x0);

        uint8 x = 0;
        while (x < claims.length) {
            if (claims[x].internalId == _internalId
                && claims[x].idReceived
                && claims[x].videoReceived
                && claims[x].deductablePayed
                && claims[x].imeiBlocked
                && claims[x].policeNoticeReport) {
                policy.customer.transfer(value);
            }
            x++;
        }
    }

    /**
     *
     * 
     */
    function payPremmiumToCustomerContractBalance(uint _internalId) public payable onlyOwner {
        require(_internalId != 0x0);

        uint8 x = 0;
        while (x < claims.length) {
            if (claims[x].internalId == _internalId &&
                claims[x].idReceived &&
                claims[x].videoReceived &&
                claims[x].deductablePayed &&
                claims[x].imeiBlocked &&
                claims[x].policeNoticeReport) {
                policy.customer.transfer(msg.value);
            }
            x++;
        }
    }

    /**
     * Returns the claims quantity
     */
    function claimsQuantity() public view returns (uint256) {
        return claims.length;
    }
    
    /**
     * Returns the sum of the claims value
     */
    function claimsValue() public view returns (uint256) {
        uint8 x = 0;
        uint256 totalValue = 0;

        while (x < claims.length) {
            totalValue += claims[x].claimValue;
            x++;
        }

        return totalValue;    
    } 
    
    function getCommissionFeePercent() public view onlyOwner returns (uint256) {
        return commissionFeePercent;
    }

    function getCommissionFeeAgentPercent() public view onlyOwner returns (uint256) {
        return commissionFeeAgentPercent;
    }

    function getCommissionFeeBrokerPercent() public view onlyOwner returns (uint256) {
        return commissionFeeBrokerPercent;
    }

    function getCommissionFeeValue() public view onlyOwner returns (uint256) {
        return commissionFeeValue;
    }

    function getCommissionFeeAgentValue() public view onlyOwner returns (uint256) {
        return commissionFeeAgentValue;
    }

    function getCommissionFeeBrokerValue() public view onlyOwner returns (uint256) {
        return commissionFeeBrokerValue;
    }

    function getPolicyBalance() public view onlyOwner returns (uint) {
        return policy.policyBalanceValue;
    }

    function getPolicyStatus() public view onlyOwner returns (StatusPolicy) {
        return status;
    }

    function getClaims(uint _internalId) 
        public 
        view 
        onlyOwner 
        returns (uint, bool, bool, bool, bool, bool) 
    {
        uint8 x;
        while (x < claims.length) {
            if(claims[x].internalId == _internalId){
                break;
            }
            x++;
        }
        return (claims[x].internalId, claims[x].idReceived, claims[x].videoReceived, 
        claims[x].deductablePayed, claims[x].imeiBlocked, claims[x].policeNoticeReport);
    }
}
