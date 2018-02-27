package io.insurtech88.ethereum;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.generated.Uint256;
import org.web3j.abi.datatypes.generated.Uint8;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.RemoteCall;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tuples.generated.Tuple2;
import org.web3j.tx.Contract;
import org.web3j.tx.TransactionManager;

/**
 * <p>Auto generated code.
 * <p><strong>Do not modify!</strong>
 * <p>Please use the <a href="https://docs.web3j.io/command_line.html">web3j command line tools</a>,
 * or the org.web3j.codegen.SolidityFunctionWrapperGenerator in the 
 * <a href="https://github.com/web3j/web3j/tree/master/codegen">codegen module</a> to update.
 *
 * <p>Generated with web3j version 3.1.1.
 */
public final class Seguro1 extends Contract {
    private static final String BINARY = "60606040526007805460a060020a60ff02191674120000000000000000000000000000000000000000179055341561003657600080fd5b61028c806100456000396000f3006060604052600436106100615763ffffffff7c0100000000000000000000000000000000000000000000000000000000600035041663313ce56781146100665780636d4ce63c1461008f578063ada71cce146100b4578063be866aaa146100ee575b600080fd5b341561007157600080fd5b61007961011c565b60405160ff909116815260200160405180910390f35b341561009a57600080fd5b6100a261013d565b60405190815260200160405180910390f35b34156100bf57600080fd5b6100ec73ffffffffffffffffffffffffffffffffffffffff60043516602435604435606435608435610142565b005b34156100f957600080fd5b610104600435610234565b60405191825260208201526040908101905180910390f35b60075474010000000000000000000000000000000000000000900460ff1681565b600190565b6007805473ffffffffffffffffffffffffffffffffffffffff19163373ffffffffffffffffffffffffffffffffffffffff161790558260c0604051908101604052808773ffffffffffffffffffffffffffffffffffffffff1681526020018681526020018581526020018481526020018281526020018381525060016000820151815473ffffffffffffffffffffffffffffffffffffffff191673ffffffffffffffffffffffffffffffffffffffff919091161781556020820151816001015560408201518160020155606082015181600301556080820151816004015560a082015160059091015550505050505050565b600880548290811061024257fe5b600091825260209091206002909102018054600190910154909150825600a165627a7a72305820df9853bdf261cc2a89a1959d0dc8418395d4febea4427657b4f31daa694cff910029";

    private Seguro1(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    private Seguro1(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public RemoteCall<BigInteger> decimals() {
        Function function = new Function("decimals", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint8>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<BigInteger> get() {
        Function function = new Function("get", 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteCall<TransactionReceipt> Seguro(String benef, BigInteger numeroApolice, BigInteger valorDoBemSegurado, BigInteger valorDoBem, BigInteger valorDaFranquia) {
        Function function = new Function(
                "Seguro", 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(benef), 
                new org.web3j.abi.datatypes.generated.Uint256(numeroApolice), 
                new org.web3j.abi.datatypes.generated.Uint256(valorDoBemSegurado), 
                new org.web3j.abi.datatypes.generated.Uint256(valorDoBem), 
                new org.web3j.abi.datatypes.generated.Uint256(valorDaFranquia)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
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

    public static RemoteCall<Seguro1> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(Seguro1.class, web3j, credentials, gasPrice, gasLimit, BINARY, "");
    }

    public static RemoteCall<Seguro1> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(Seguro1.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, "");
    }

    public static Seguro1 load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new Seguro1(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    public static Seguro1 load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new Seguro1(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }
}
