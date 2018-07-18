pragma solidity ^0.4.24;

contract 88SmartProtectionPolicy {


    enum StatusPolicy { VIGENTE, LIQUIDADO, INATIVO, SINISTRO }

    StatusPolicy status;
    StatusPolicy constant defaultStatus = StatusApolice.VIGENTE;
    Policy policy;
    address owner;
    uint8 public decimals = 18;

    struct Policy {
        /** Contains the policy start date and time **/
        uint16 startPolicyTime;        
        uint256 policyNumber;
        uint256 valueOfProperty;
        uint16 premium;
        uint256 deductablePaymentValue;
    }

    /** The address of the customer created by mobile aplication **/
    address customer;

    /** The addres of the channel, who is provided the negociation channel **/
    address broker;

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
    uint16 comissionFeePercent;

    /** The percent of fee to the Broker **/
    uint16 comissionFeeBrokerPercent;

    /** The percent of fee to the agent **/
    uint16 comissionFeeAgentPercent;

    /**  **/
    uint16 comissionFeeBrokerValue;
    uint16 comissionFeeAgentValue;


}