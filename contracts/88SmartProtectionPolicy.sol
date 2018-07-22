pragma solidity ^0.4.24;

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
    address public agent;
    bool public agentPayed = false;

    /** The address of the broker **/
    address public broker;  
    bool public brokerPayed = false;

    /** This event changes the Apolice Status, and is called when something very important occurs **/
    event ChangeStatus(StatusPolicy status, uint256 eventValue);

    /** This event changes the Apolice Status, and is called when something very important occurs **/
    event ComissionPayed(address _address, uint256 eventValue);

    /**
    * The Claim object, one contract can be zero or n claims
    * ID is the unique identifier comes from internal system
    **/
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
    Claim[] public claims;

    /** The percent of fee **/
    uint256 comissionFeePercent = 2;
    uint256 comissionFeeValue;

    /** The percent (%) of fee to the Broker **/
    uint256 comissionFeeBrokerPercent = 1;

    /** The percent (%) of fee to the agent **/
    uint256 comissionFeeAgentPercent = 1;

    /** The comission values for stakeholders **/
    uint256 comissionFeeBrokerValue;/** The value of fee in Ether to be sended to Broker **/
    uint256 comissionFeeAgentValue;/** The value of fee in Ether to be sended to Agent **/
    
    function notZero(uint _value) private {
        require (_value != 0x0);
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }
    
    constructor (address acustomeraddress, string acustomerName, uint256 apolicynumber, uint256 avalueOfProperty, uint256 apremium, uint256 afranchise, string ainsuredItem) public {
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
            contractDuration : 1 years,
            policyBalanceValue : apremium
        });

        emit ChangeStatus(defaultStatus, apremium);
    }
    

    /**
     * 
    **/
    function setFeeComissionsPercent(uint16 broker, uint16 agent) onlyOwner() public returns (bool){
        /**Avoid zero fee comission **/
        notZero(broker);
        notZero(agent);
        
        /** The percent (%) of fee to the Broker **/
        comissionFeeBrokerPercent = broker;

        /** The percent (%) of fee to the agent **/
        comissionFeeAgentPercent = agent; 
        
        /** The percent of fee **/
        comissionFeePercent = broker + agent;
        
        return true;
    }

    /**
    * Needs to be called after set Comissions Percent
    * send a percent of Ether received to:
    * Agent
    * Broker
    **/
    function splitComissions() public onlyOwner payable returns(bool) {
        uint totalComissionPayable = 0;

        /**
        * requires called only if values are not calculated yet
        **/
        require((comissionFeeAgentValue == 0x0) && (comissionFeeBrokerValue == 0x0));

        /**
        * Calculates and send a percent of ether to Agent
        **/
        if(comissionFeeAgentPercent != 0x0 ){
            comissionFeeAgentValue = msg.value * (comissionFeeAgentPercent / 100);
            totalComissionPayable += comissionFeeAgentValue;
        }

        /**
        * Calculates and send a percent of ether to Broker
        **/
        if(comissionFeeBrokerPercent != 0x0 ){
            comissionFeeBrokerValue = msg.value * (comissionFeeBrokerPercent / 100);
            totalComissionPayable += comissionFeeBrokerValue;
        }

        /**
        * Sets only one time, comission fee value per execution 
        **/
        comissionFeeValue = totalComissionPayable; 
    }

    /**
    * Needs to be called after comission split
    *
    */
    function sendComissionSplitedAgent() public onlyOwner returns (bool){
        if(comissionFeeAgentValue != 0x0 ){
            agent.transfer(comissionFeeAgentValue);
            agentPayed = true;
        }
        return true;
    }

    /**
    * Needs to be called after comission split
    *
    */
    function sendComissionSplitedBroker() public onlyOwner returns (bool){
        if(comissionFeeBrokerValue != 0x0 ){
            broker.transfer(comissionFeeBrokerValue);
            brokerPayed = true;
        }
        return true;
    }
    
    /**
     * Creates a new claim
     * First Notice of Loss
     **/
    function FNOL(uint _internalId, uint _value) onlyOwner public returns (uint256){
        /**
        * The claim value needs to be less than policy balance
        **/
        require(policy.policyBalanceValue - _value >= 0x0);
        
        /**
        * Add the claim to the claim list
        *
        **/
        uint _id = claims.push(Claim({internalId: _internalId, id: _id, claimValue: _value, dateTime: now}));

        /**
        * Set the new balance of policy
        **/
        policy.policyBalanceValue -= _value;

        /**
        * Set policy status CONTAIN_CLAIN only if policy status is different
        **/
        if(status != StatusPolicy.CONTAIN_CLAIM){
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
        if (msg.sender == owner) {
            status = StatusPolicy.INACTIVE;
            emit ChangeStatus(status, policy.policyBalanceValue);
            selfdestruct(owner);
        }
    }

    /**
    * This method
    **/
    function setClaimDocumentationWorkFlow(uint _internalId, bool _idReceived, bool _videoReceived, bool _deductablePayed, bool _imeiBlock, bool _policeNoticeReport) public onlyOwner {
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
    * Returns the claims quantity
    **/
    function claimsQuantity() public view returns (uint256) {
        return claims.length;
    }
    
    /**
    * Returns the sum of the claims value
    **/
    function claimsValue() public view returns (uint256) {
        uint8 x = 0;
        uint256 totalValue = 0;

        while (x < claims.length) {
            totalValue += claims[x].claimValue;
            x++;
        }

        return totalValue;    
    } 





}