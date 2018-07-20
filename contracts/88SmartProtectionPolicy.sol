pragma solidity ^0.4.24;

contract SmartProtectionPolicy {


    enum StatusPolicy { ACTIVE, FINISHED, INACTIVE, CONTAIN_CLAIM }

    StatusPolicy status;
    StatusPolicy constant defaultStatus = StatusPolicy.ACTIVE;
    Policy policy;
    address owner; // 88 Ethereum Account
    uint8 public decimals = 18;

    struct Policy {
        /** Contains the policy start date and time **/
        uint256 startPolicyTime;        
        uint256 policyNumber;
        uint256 valueOfProperty;
        uint256 franchiseValue;
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

    /** The address of the broker **/
    address broker;  

    /** This event changes the Apolice Status, and is called when something very important occurs **/
    event ChangeStatus(StatusPolicy status, uint256 eventValue);

    /**
    * The Claim object, one contract can be zero or n claims
    * ID is the unique identifier comes from internal system
    **/
    struct Claim {
        uint id;
        uint256 claimValue;
    }

    /** One contract can have zero or n claims **/
    Claim[] public claims;


    /** The percent of fee **/
    uint16 comissionFeePercent = 2;

    /** The percent (%) of fee to the Broker **/
    uint16 comissionFeeBrokerPercent = 1;

    /** The percent (%) of fee to the agent **/
    uint16 comissionFeeAgentPercent = 1;

    /** The comission values for stakeholders **/
    uint16 comissionFeeBrokerValue;/** The value of fee in Ether to be sended to Broker **/
    uint16 comissionFeeAgentValue;/** The value of fee in Ether to be sended to Agent **/
    
    function notZero(uint16 _value) private {
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

        policy = Policy({
             startPolicyTime : now,
            policyNumber : apolicynumber,
            valueOfProperty : avalueOfProperty,
            franchiseValue : afranchise,
            insuredItem : ainsuredItem,
            customerName : acustomerName,
            customer : acustomeraddress,
            premium : apremium,
            deductablePaymentValue : apremium,
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
     * Creates a new claim
     **/
    function createClaim() onlyOwner public returns (uint256){
        return 0;
    }





}