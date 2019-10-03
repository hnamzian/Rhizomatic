pragma solidity ^0.5.0;

contract RhizoToken {

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    
    uint256 tokenPerEther = 100000;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
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

    function buyToken() public payable {
        require(msg.value != 0, "invalid amount of invest!");
        
        uint256 tokens = (msg.value * tokenPerEther) / 1 ether;

        _totalSupply = _totalSupply + tokens;
        _balances[msg.sender] = _balances[msg.sender] + tokens;
        emit Transfer(address(0), msg.sender, tokens);
    }

}
