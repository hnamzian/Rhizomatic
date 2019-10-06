pragma solidity ^0.5.0;

import "./Whitelist.sol";

contract ICasino {
    address payable owner;

    constructor() internal {
        owner = msg.sender;
    }

    function startBet(uint256 _minBet) public {}
    function bet(uint256 _rn) public payable {}
    function endBet(uint256 _rn) public {}
    function getWinner() public returns (uint256) {}
}

contract Casino is ICasino, Whitelist {
    enum status {INACTIVE, STARTED, RUNNING, ENDED}
    status betStatus;

    uint256 minBet;

    bytes32 lastHash;

    uint256 public winnerId;
    Profile public winner;

    address payable owner;

    constructor() internal {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "");
        _;
    }

    function startBet(uint256 _minBet) public onlyOwner {
        require(betStatus == status.INACTIVE, "");
        betStatus = status.STARTED;
        minBet = _minBet;
    }

    function bet(uint256 _rn) public payable onlyWhtielisted {
        owner.transfer(msg.value);
        lastHash = keccak256(abi.encodePacked(_rn, lastHash));
        _setWinner();
    }

    function endBet(uint256 _rn) public onlyOwner {
        require(betStatus == status.RUNNING, "");
        lastHash = keccak256(abi.encodePacked(_rn, lastHash));
        betStatus = status.ENDED;
    }

    function _setWinner() internal {
        winnerId = uint(lastHash) % userAddress.length;
        address winnerAddress = userAddress[winnerId];
        winner = users[winnerAddress];
    }
}
