package io.insurtech88.ethereum;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import org.web3j.abi.EventEncoder;
import org.web3j.abi.EventValues;
import org.web3j.abi.FunctionEncoder;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Event;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;
import org.web3j.abi.datatypes.generated.Uint256;
import org.web3j.abi.datatypes.generated.Uint8;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameter;
import org.web3j.protocol.core.RemoteCall;
import org.web3j.protocol.core.methods.request.EthFilter;
import org.web3j.protocol.core.methods.response.Log;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tuples.generated.Tuple2;
import org.web3j.tx.Contract;
import org.web3j.tx.TransactionManager;
import rx.Observable;
import rx.functions.Func1;

/**
 * <p>Auto generated code.
 * <p><strong>Do not modify!</strong>
 * <p>Please use the <a href="https://docs.web3j.io/command_line.html">web3j command line tools</a>,
 * or the org.web3j.codegen.SolidityFunctionWrapperGenerator in the 
 * <a href="https://github.com/web3j/web3j/tree/master/codegen">codegen module</a> to update.
 *
 * <p>Generated with web3j version 3.1.1.
 */
public final class Seguro extends Contract {
    private static final String BINARY = "60606040526007805460a060020a60ff02191674120000000000000000000000000000000000000000179055341561003657600080fd5b60405160a080610d54833981016040528080519190602001805191906020018051919060200180519190602001805160078054600160a060020a03191633600160a060020a0316179055915083905060c06040519081016040528087600160a060020a0316815260200186815260200185815260200184815260200182815260200183815250600160008201518154600160a060020a031916600160a060020a03919091161781556020820151816001015560408201518160020155606082015181600301556080820151816004015560a0820151600590910155507fc5411a5d2c1e956f71d2ac138fd1ac43b63acaa4c0089074e7e5a7f5aa456eac6000856040518083600381111561014657fe5b60ff1681526020018281526020019250505060405180910390a1505050505050610bdf806101756000396000f3006060604052600436106100fb5763ffffffff7c0100000000000000000000000000000000000000000000000000000000600035041663070858b881146101005780631d24349a1461012f5780632994ba89146101545780632a6b820e14610167578063313ce56714610171578063331ee2f01461012f578063377b8e8d1461019a5780633ad93452146101ad5780634bb278f3146101c05780634e69d560146101d357806367af8c8b146101e657806379c730d514610273578063893d20e8146102865780638cf80b00146102995780639e71ddb9146102ac578063be866aaa146102ba578063f08693ef146102e8578063f08a4633146102f0575b600080fd5b341561010b57600080fd5b610113610303565b604051600160a060020a03909116815260200160405180910390f35b341561013a57600080fd5b610142610313565b60405190815260200160405180910390f35b341561015f57600080fd5b610142610319565b61016f610360565b005b341561017c57600080fd5b6101846103dc565b60405160ff909116815260200160405180910390f35b34156101a557600080fd5b6101426103fd565b34156101b857600080fd5b610142610403565b34156101cb57600080fd5b61016f610409565b34156101de57600080fd5b610142610490565b34156101f157600080fd5b6101fc6004356104a7565b60405160208082528190810183818151815260200191508051906020019080838360005b83811015610238578082015183820152602001610220565b50505050905090810190601f1680156102655780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b341561027e57600080fd5b61014261056f565b341561029157600080fd5b610113610575565b34156102a457600080fd5b610142610584565b61016f60043560243561058a565b34156102c557600080fd5b6102d06004356106b7565b60405191825260208201526040908101905180910390f35b61016f6106e3565b34156102fb57600080fd5b6101426106fe565b600154600160a060020a03165b90565b60035490565b600080805b60085460ff8316101561035a576008805460ff841690811061033c57fe5b6000918252602090912060016002909202018101549201910161031e565b92915050565b60075433600160a060020a03908116911614156103da576000805460ff1916600117908190556003547fc5411a5d2c1e956f71d2ac138fd1ac43b63acaa4c0089074e7e5a7f5aa456eac9160ff1690604051808360038111156103bf57fe5b60ff1681526020018281526020019250505060405180910390a15b565b60075474010000000000000000000000000000000000000000900460ff1681565b60055490565b60085490565b60075433600160a060020a03908116911614156103da576000805460ff1916600217908190556003547fc5411a5d2c1e956f71d2ac138fd1ac43b63acaa4c0089074e7e5a7f5aa456eac9160ff16906040518083600381111561046857fe5b60ff1681526020018281526020019250505060405180910390a1600754600160a060020a0316ff5b6000805460ff1660038111156104a257fe5b905090565b6104af610b4c565b61035a61050e60408051908101604052600381527f49443a0000000000000000000000000000000000000000000000000000000000602082015260088054869081106104f757fe5b906000526020600020906002020160000154610704565b61056a60408051908101604052600681527f56414c4f523a00000000000000000000000000000000000000000000000000006020820152600880548790811061055357fe5b906000526020600020906002020160010154610704565b610892565b60045490565b600754600160a060020a031690565b60025490565b60075433600160a060020a03908116911614156106b357670de0b6b3a764000034146105b557600080fd5b8115156105c157600080fd5b8015156105cd57600080fd5b60035460055482900311156105e157600080fd5b60088054600181016105f38382610b5e565b9160005260206000209060020201600060408051908101604052858152602081018590529190508151815560208201516001919091015550506005805482900390556000805460ff1916600317908190557fc5411a5d2c1e956f71d2ac138fd1ac43b63acaa4c0089074e7e5a7f5aa456eac9060ff16826040518083600381111561067a57fe5b60ff1681526020018281526020019250505060405180910390a18181600160a060020a0333163460405190815260200160405180910390a35b5050565b60088054829081106106c557fe5b60009182526020909120600290910201805460019091015490915082565b60015433600160a060020a039081169116146103da57600080fd5b60065490565b61070c610b4c565b6000610716610b4c565b600080610721610b4c565b610729610b4c565b6000606496508660405180591061073d5750595b818152601f19601f830116810160200160405290509550600094505b88156107a457600a89069350600a890498508360300160f860020a0286868060010197508151811061078757fe5b906020010190600160f860020a031916908160001a905350610759565b899250848351016040518059106107b85750595b818152601f19601f830116810160200160405290509150600090505b8251811015610827578281815181106107e957fe5b016020015160f860020a900460f860020a0282828151811061080757fe5b906020010190600160f860020a031916908160001a9053506001016107d4565b5060005b8481101561088557858160018703038151811061084457fe5b016020015160f860020a900460f860020a0282845183018151811061086557fe5b906020010190600160f860020a031916908160001a90535060010161082b565b5098975050505050505050565b61089a610b4c565b6108d58383602060405190810160405280600081525060206040519081016040528060008152506020604051908101604052600081526108dc565b9392505050565b6108e4610b4c565b6108ec610b4c565b6108f4610b4c565b6108fc610b4c565b610904610b4c565b61090c610b4c565b610914610b4c565b61091c610b4c565b6000808e98508d97508c96508b95508a94508451865188518a518c51010101016040518059106109495750595b818152601f19601f83011681016020016040529050935083925060009150600090505b88518110156109c55788818151811061098157fe5b016020015160f860020a900460f860020a028383806001019450815181106109a557fe5b906020010190600160f860020a031916908160001a90535060010161096c565b5060005b8751811015610a22578781815181106109de57fe5b016020015160f860020a900460f860020a02838380600101945081518110610a0257fe5b906020010190600160f860020a031916908160001a9053506001016109c9565b5060005b8651811015610a7f57868181518110610a3b57fe5b016020015160f860020a900460f860020a02838380600101945081518110610a5f57fe5b906020010190600160f860020a031916908160001a905350600101610a26565b5060005b8551811015610adc57858181518110610a9857fe5b016020015160f860020a900460f860020a02838380600101945081518110610abc57fe5b906020010190600160f860020a031916908160001a905350600101610a83565b5060005b8451811015610b3957848181518110610af557fe5b016020015160f860020a900460f860020a02838380600101945081518110610b1957fe5b906020010190600160f860020a031916908160001a905350600101610ae0565b50909d9c50505050505050505050505050565b60206040519081016040526000815290565b815481835581811511610b8a57600202816002028360005260206000209182019101610b8a9190610b8f565b505050565b61031091905b80821115610baf5760008082556001820155600201610b95565b50905600a165627a7a7230582003155bd46be68379d8b28673a990e3ce6bddf15e7400ec64b979e429965c7b340029";

    private Seguro(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    private Seguro(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public List<ChangeStatusEventResponse> getChangeStatusEvents(TransactionReceipt transactionReceipt) {
        final Event event = new Event("ChangeStatus", 
                Arrays.<TypeReference<?>>asList(),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint8>() {}, new TypeReference<Uint256>() {}));
        List<EventValues> valueList = extractEventParameters(event, transactionReceipt);
        ArrayList<ChangeStatusEventResponse> responses = new ArrayList<ChangeStatusEventResponse>(valueList.size());
        for (EventValues eventValues : valueList) {
            ChangeStatusEventResponse typedResponse = new ChangeStatusEventResponse();
            typedResponse.status = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
            typedResponse.valueEvento = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public Observable<ChangeStatusEventResponse> changeStatusEventObservable(DefaultBlockParameter startBlock, DefaultBlockParameter endBlock) {
        final Event event = new Event("ChangeStatus", 
                Arrays.<TypeReference<?>>asList(),
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint8>() {}, new TypeReference<Uint256>() {}));
        EthFilter filter = new EthFilter(startBlock, endBlock, getContractAddress());
        filter.addSingleTopic(EventEncoder.encode(event));
        return web3j.ethLogObservable(filter).map(new Func1<Log, ChangeStatusEventResponse>() {
            @Override
            public ChangeStatusEventResponse call(Log log) {
                EventValues eventValues = extractEventParameters(event, log);
                ChangeStatusEventResponse typedResponse = new ChangeStatusEventResponse();
                typedResponse.status = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
                typedResponse.valueEvento = (BigInteger) eventValues.getNonIndexedValues().get(1).getValue();
                return typedResponse;
            }
        });
    }

    public RemoteCall<String> getBeneficiario() {
        Function function = new Function("getBeneficiario", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteCall<BigInteger> getApoliceValorDoBemSegurado() {
        Function function = new Function("getApoliceValorDoBemSegurado", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<BigInteger> getSinistrosValorTotal() {
        Function function = new Function("getSinistrosValorTotal", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<TransactionReceipt> liquidarContrato(BigInteger weiValue) {
        Function function = new Function(
                "liquidarContrato", 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function, weiValue);
    }

    public RemoteCall<BigInteger> decimals() {
        Function function = new Function("decimals", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint8>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<BigInteger> getApoliceValorBemSegurado() {
        Function function = new Function("getApoliceValorBemSegurado", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<BigInteger> getApoliceValorSaldoBemSegurado() {
        Function function = new Function("getApoliceValorSaldoBemSegurado", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<BigInteger> getSinistrosQtdTotal() {
        Function function = new Function("getSinistrosQtdTotal", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<TransactionReceipt> finalize() {
        Function function = new Function(
                "finalize", 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<BigInteger> getStatus() {
        Function function = new Function("getStatus", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<String> getSinistrosPorId(BigInteger id) {
        Function function = new Function("getSinistrosPorId", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(id)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Utf8String>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteCall<BigInteger> getApoliceValorDoBem() {
        Function function = new Function("getApoliceValorDoBem", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<String> getOwner() {
        Function function = new Function("getOwner", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteCall<BigInteger> getApoliceNumber() {
        Function function = new Function("getApoliceNumber", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<TransactionReceipt> addSinistro(BigInteger _id, BigInteger _value, BigInteger weiValue) {
        Function function = new Function(
                "addSinistro", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(_id), 
                new org.web3j.abi.datatypes.generated.Uint256(_value)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function, weiValue);
    }

    public RemoteCall<Tuple2<BigInteger, BigInteger>> sinistros(BigInteger param0) {
        final Function function = new Function("sinistros", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(param0)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
        return new RemoteCall<Tuple2<BigInteger, BigInteger>>(
                new Callable<Tuple2<BigInteger, BigInteger>>() {
                    @Override
                    public Tuple2<BigInteger, BigInteger> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);;
                        return new Tuple2<BigInteger, BigInteger>(
                                (BigInteger) results.get(0).getValue(), 
                                (BigInteger) results.get(1).getValue());
                    }
                });
    }

    public RemoteCall<TransactionReceipt> setarPagamento(BigInteger weiValue) {
        Function function = new Function(
                "setarPagamento", 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function, weiValue);
    }

    public RemoteCall<BigInteger> getApoliceValorFranquia() {
        Function function = new Function("getApoliceValorFranquia", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public static RemoteCall<Seguro> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit, String benef, BigInteger numeroApolice, BigInteger valorDoBemSegurado, BigInteger valorDoBem, BigInteger valorDaFranquia) {
        String encodedConstructor = FunctionEncoder.encodeConstructor(Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(benef), 
                new org.web3j.abi.datatypes.generated.Uint256(numeroApolice), 
                new org.web3j.abi.datatypes.generated.Uint256(valorDoBemSegurado), 
                new org.web3j.abi.datatypes.generated.Uint256(valorDoBem), 
                new org.web3j.abi.datatypes.generated.Uint256(valorDaFranquia)));
        return deployRemoteCall(Seguro.class, web3j, credentials, gasPrice, gasLimit, BINARY, encodedConstructor);
    }

    public static RemoteCall<Seguro> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit, String benef, BigInteger numeroApolice, BigInteger valorDoBemSegurado, BigInteger valorDoBem, BigInteger valorDaFranquia) {
        String encodedConstructor = FunctionEncoder.encodeConstructor(Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(benef), 
                new org.web3j.abi.datatypes.generated.Uint256(numeroApolice), 
                new org.web3j.abi.datatypes.generated.Uint256(valorDoBemSegurado), 
                new org.web3j.abi.datatypes.generated.Uint256(valorDoBem), 
                new org.web3j.abi.datatypes.generated.Uint256(valorDaFranquia)));
        return deployRemoteCall(Seguro.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, encodedConstructor);
    }

    public static Seguro load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new Seguro(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    public static Seguro load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new Seguro(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public static class ChangeStatusEventResponse {
        public BigInteger status;

        public BigInteger valueEvento;
    }
}
