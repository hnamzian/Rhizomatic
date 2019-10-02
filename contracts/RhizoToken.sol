pragma solidity ^0.5.0;

contract IRhizoToken {
    function balanceOf(address account) public view returns (uint256) {}
    function transfer(address recipient, uint256 amount) public returns (bool) {}
    function _transfer(address sender, address recipient, uint256 amount) internal {}
    function mint(address account, uint256 amount) public payable {}
}

contract RhizoToken is IRhizoToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 private totalSupply;

    mapping (address => uint256) private _balances;

    uint256 tokenPerEther = 1000;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor (string memory _name, string memory _symbol, uint8 _decimals) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "transfer to the zero address");

        _balances[msg.sender] = _balances[msg.sender] - amount;
        _balances[recipient] = _balances[recipient] + amount;
        emit Transfer(msg.sender, recipient, amount);
    }

    function mint(address account, uint256 amount) public payable {
        require(account != address(0), "mint to the zero address");
        require(msg.value != 0, "invalid amount of invest!");

        uint256 tokens = (msg.value * 1000) / 1 ether;

        totalSupply = totalSupply + tokens;
        _balances[account] = _balances[account] + tokens;
        emit Transfer(address(0), account, amount);
    }

    function setTokenPrice(uint256 _tokenPerEther) public {
        tokenPerEther = _tokenPerEther;
    }

    function getTokenPrice() public view returns (uint256) {
        return tokenPerEther;
    }

}
