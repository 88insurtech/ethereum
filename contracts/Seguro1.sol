pragma solidity ^0.4.17;

contract Seguro1 {

    enum StatusApolice { VIGENTE, LIQUIDADO, INATIVO, SINISTRO }
    StatusApolice status;
    StatusApolice constant defaultStatus = StatusApolice.VIGENTE;
    Apolice apolice;
    address owner;
    uint8 public decimals = 18;

    //event ChangeStatus(StatusApolice, uint256 valueEvento);

    struct Cobertura {
        uint id;
        uint256 valorCoberto;
    }

    struct Sinistro {
        uint id;
        uint256 valorSinistro;
    }    

    struct Apolice {
        address beneficiario;
        uint256 apoliceNumber;
        uint256 valorBemSegurado;
        uint256 valorBem;
        uint256 valorSaldo;
        uint256 valorFranquia;
    }

    Sinistro[] public sinistros;


    /*
    * Funcao construtora, inicializa a apolice, seta o owner do contrato
    * O valor da variavel valorSaldo eh identico ao valor do seguro neste momento, ou seja
    * neste momento o cliente tem o saldo completo
    *apolice = Apolice(benef, numeroApolice, valorDoBemSegurado, valorDoBem, valorDoBemSegurado, valorDaFranquia);
    */
    function Seguro(address benef, uint256 numeroApolice, uint256 valorDoBemSegurado, uint256 valorDoBem, uint256 valorDaFranquia) public
    {
        owner = msg.sender;
        uint256 valorSaldoApolice = valorDoBemSegurado;
        apolice = Apolice({beneficiario: benef, apoliceNumber: numeroApolice, valorBemSegurado: valorDoBemSegurado, valorBem: valorDoBem, valorSaldo: valorSaldoApolice, valorFranquia:valorDaFranquia});
        //ChangeStatus(defaultStatus, valorDoBemSegurado);
    }
 
    function get() public pure returns (uint256) {
        return 1;
    }

    

}

