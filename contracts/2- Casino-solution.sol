pragma solidity ^0.5.0;

// 0- Import Whitelist contract
import "./Whitelist.sol";

// 3- Create a contract named "Casino" which inherits "ICasino" and "Whitelist" contracts
contract Casino is Whitelist {
    // 4A- Define an Enum named "status" with possible values of:
    // INACTIVE, STARTED, RUNNING, ENDED
    // 4B- Define a state variable "betStatus" of type status Enum
    enum status {INACTIVE, STARTED, RUNNING, ENDED}
    status betStatus;

    // 5- Define a state variable "minBet" of type 256-bit unsigned integer
    uint256 minBet;

    // 8- Define "lastHash" of type bytes32
    bytes32 lastHash;

    // 16- Define "winnerId" of type uint256
    uint256 public winnerId;

    // 17- Define "winner" of type Profile
    // hint: use whitelist contract
    Profile public winner;

    address payable owner;

    constructor() public {
        owner = msg.sender;
    }

    // 27A- Define modifier "onlyOwner"
    // 27C- Go ahead to "startBet" function and make it to be called only by "owner"
    modifier onlyOwner() {
        // 27B- Requrie the message sender is equal to "owner"
        require(msg.sender == owner, "");
        _;
    }

    // 6- Define a public function named "startBet" which accepts "_minBet" of type uint256
    function startBet(uint256 _minBet) public onlyOwner {
        // 7A- Require "betStatus" is exactle INACTIVE
        require(betStatus == status.INACTIVE, "");
        // 7B- set "betStatus" to STARTED
        betStatus = status.STARTED;
        // 7C- set "minBet" to input argument "_minBet"
        minBet = _minBet;
    }

    // 12- Define a public payable function named "bet" which accepts "_rn" of type uint256
    function bet(uint256 _rn) public payable onlyWhtielisted {
        // 13- Require sent ether value is greater than "minBet" and return error message at falsy case:
        // "Insufficient Bet value"
        require(msg.value > minBet, "Insufficient Bet value");
        // 14- Transfer sent ether values to owner's address
        owner.transfer(msg.value);
        // 15- reCompute "lastHash" using "_setHash" function
        _setHash(_rn);
        // 21- reCompute winner using "_setWinner" function
        _setWinner();
    }

    // 22- Define a function "endBet" which accepts "_rn" of type uint256
    function endBet(uint256 _rn) public onlyOwner {
        // 23- Requrie "betStatus" is exactly RUNNING and return error message at falsy case:
        // "bet is not running!"
        require(betStatus == status.RUNNING, "bet is not running!");
        // 24- reCompute "lastHash" using "_setHash" function
        _setHash(_rn);
        // 25- reCompute winner using "_setWinner" function
        _setWinner();
        // 26- Set "betStatus" as ENDED
        betStatus = status.ENDED;
    }

    // 9- Define an internal function "_setHash" which accepts "_rn" of type uint256
    function _setHash(uint256 _rn) internal {
        // 10- Define "packedBytes" and pack "_rn" and "lastHash"
        bytes memory packedBytes = abi.encodePacked(_rn, lastHash);
        // 11- Use keccak256() function to compute hash of "packedBytes"
        lastHash = keccak256(packedBytes);
    }

    // 18- Define an internal function named "_setWinner" to reCompute winner of the bet
    function _setWinner() internal {
        // THINK: Use lastHash to find an index for the winner
        // hint: get number of users from userAddresses length
        // hint: use variable casting concept
        winnerId = uint(lastHash) % userAddress.length;
        // 19- Find winner address using whitelist contract
        address winnerAddress = userAddress[winnerId];
        // 20- Get winner profile into "winner" using whitelist contract
        winner = users[winnerAddress];
    }
}
