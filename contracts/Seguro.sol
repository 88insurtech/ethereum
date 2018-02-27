pragma solidity ^0.4.17;

contract Seguro {

    enum StatusApolice { VIGENTE, LIQUIDADO, INATIVO, SINISTRO }
    StatusApolice status;
    StatusApolice constant defaultStatus = StatusApolice.VIGENTE;
    Apolice apolice;
    address owner;
    uint8 public decimals = 18;

    event ChangeStatus(StatusApolice status, uint256 valueEvento);

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

        //mapping (uint => Cobertura) coberturas;
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
        ChangeStatus(defaultStatus, valorDoBemSegurado);
    }

    function addSinistro(uint _id, uint256 _value) public payable 
    {
        
        if(msg.sender == owner){

            require(msg.value == 1 ether);
        
            require(_id != 0x0);
        
            require(_value != 0x0);
        
            require(apolice.valorSaldo - _value <= apolice.valorBemSegurado);
        
            sinistros.push(Sinistro({id: _id, valorSinistro:_value}));
        
            apolice.valorSaldo -= _value;
            
            status = StatusApolice.SINISTRO;
        
            ChangeStatus(status, _value);

            log3(
                bytes32(msg.value),
                bytes32(msg.sender),
                bytes32(_value),
                bytes32(_id)
            );
            
        }
    }
    
    function setarPagamento() public payable {
        require(msg.sender == apolice.beneficiario);
    }

    /*
    * Funcao chamada quando o contrato expira
    */
    function liquidarContrato() public payable
    {
        if(msg.sender == owner){
            status = StatusApolice.LIQUIDADO;
            ChangeStatus(status, apolice.valorBemSegurado);
        }
    }
    
    function getSinistrosQtdTotal() public view returns (uint256)
    {
        return sinistros.length;
    }
    
    function getSinistrosValorTotal() public view returns (uint256)
    {
        uint8 x = 0;
        uint256 valorTotal = 0;
        while(x < sinistros.length)
        {
            valorTotal += sinistros[x].valorSinistro;
            x++;
        }

        return valorTotal;    
    }    

    function getSinistrosPorId(uint256 id) public view returns (string)
    {
       return strConcat(appendUintToString('ID:' ,   sinistros[id].id ), appendUintToString('VALOR:', sinistros[id].valorSinistro));
    }

    /*
    * a funcao suicide nao eh mais utilizadabytes32
    * EIP 6 - Recomenda a nao utilizacao do termo suicide, e sua troca por selfdestruct
    */
    function finalizarApolice() public {
        if(msg.sender == owner){
            status = StatusApolice.INATIVO;
            ChangeStatus(status, apolice.valorBemSegurado);
            selfdestruct(owner);
        }
    }

    function getStatus() public view returns (uint)
    {
        return uint(status);
    }

    function getApoliceNumber() public view returns (uint256){
        return apolice.apoliceNumber;
    }

    function getApoliceValorSaldoBemSegurado() public view returns (uint256){
        return apolice.valorSaldo;
    }    

    function getApoliceValorBemSegurado() public view returns (uint256){
        return apolice.valorBemSegurado;
    }

    function getApoliceValorFranquia() public view returns (uint256){
        return apolice.valorFranquia;
    }

    function getApoliceValorDoBem() public view returns (uint256){
        return apolice.valorBem;
    }

    function getApoliceValorDoBemSegurado() public view returns (uint256){
        return apolice.valorBemSegurado;
    }

    function getOwner() public view returns (address){
        return owner;
    }

    function getBeneficiario() public view returns (address){
        return apolice.beneficiario;
    }

    function uintToString(uint v) internal pure returns (string str) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory s = new bytes(i);
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - 1 - j];
        }
        str = string(s);
    }

    function appendUintToString(string inStr, uint v) internal pure returns (string str) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory inStrb = bytes(inStr);
        bytes memory s = new bytes(inStrb.length + i);
        uint j;
        for (j = 0; j < inStrb.length; j++) {
            s[j] = inStrb[j];
        }
        for (j = 0; j < i; j++) {
            s[j + inStrb.length] = reversed[i - 1 - j];
        }
        str = string(s);
    }
    
function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
    bytes memory _ba = bytes(_a);
    bytes memory _bb = bytes(_b);
    bytes memory _bc = bytes(_c);
    bytes memory _bd = bytes(_d);
    bytes memory _be = bytes(_e);
    string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
    bytes memory babcde = bytes(abcde);
    uint k = 0;
    for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
    for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
    for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
    for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
    for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
    return string(babcde);
}

function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
    return strConcat(_a, _b, _c, _d, "");
}

function strConcat(string _a, string _b, string _c) internal pure returns (string) {
    return strConcat(_a, _b, _c, "", "");
}

function strConcat(string _a, string _b) internal pure returns (string) {
    return strConcat(_a, _b, "", "", "");
}

}

