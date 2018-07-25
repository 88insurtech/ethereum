pragma solidity ^0.4.19;

import "../contracts/Seguro.sol";
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

contract TestSeguro {
    
    function testStatusInicial() public {
        Seguro seguro = Seguro(DeployedAddresses.Seguro());
        uint expected = 0;
        Assert.equal(seguro.getStatus(), expected, "Status invalido");
    }

    function testSinistro() public {
        Seguro seguro = Seguro(DeployedAddresses.Seguro());
        uint expected = 3;
        seguro.addSinistro(1, 100);
        Assert.equal(seguro.getStatus(), expected, "Status invalido");
    }

    function testSaldo() public {
        Seguro seguro = Seguro(DeployedAddresses.Seguro());
        seguro.addSinistro(1, 100);
        uint256 valor = 600;
        Assert.equal(seguro.getApoliceSaldo(), valor, "Valor remanescente invalido");
    }
}