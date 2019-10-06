pragma solidity ^0.5.0;

contract Whitelist {
    struct Profile {
        string name;
        string email;
        string proffession;
        bool created;
    }

    mapping (address => Profile) users;
    address[] userAddress;

    modifier onlyWhtielisted() {
        require(users[msg.sender].created == true, "");
        _;
    }

    function addUser(string memory name, string memory email, string memory proffession) public {
        require(keccak256(abi.encodePacked(name)) != keccak256(abi.encodePacked("")), "name must not be empty!");
        require(keccak256(abi.encodePacked(email)) != keccak256(abi.encodePacked("")), "email must not be empty!");
        require(keccak256(abi.encodePacked(proffession)) != keccak256(abi.encodePacked("")), "proffession must not be empty!");

        Profile storage _profile = users[msg.sender];

        require(_profile.created == false, "Profile with the same address already exists!");

        _profile.name = name;
        _profile.email = email;
        _profile.proffession = proffession;
        _profile.created = true;

        userAddress.push(msg.sender);
    }

    function getUser(uint256 userId) public view returns (string memory, string memory, string memory) {
        address _userAddress = userAddress[userId];
        Profile memory _profile = users[_userAddress];
        return (_profile.name, _profile.email, _profile.proffession);
    }

}