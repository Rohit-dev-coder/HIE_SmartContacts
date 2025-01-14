// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

struct User {
    bytes32 role;
    address contractAddr;
    bytes32 name;
    bytes32 hashedPassword; // Store only the hashed password
    address userId;
}

contract Authorization {
    address public owner;
    mapping(bytes32 => User) private users; // Make mapping private for added security

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Admin required");
        _;
    }

    function addUser(
        address contractAddr,
        bytes32 role,
        bytes32 name,
        bytes32 email,
        bytes32 password, // Accept plaintext but immediately hash it
        address userId
    ) public onlyOwner {
        User memory u;
        u.role = role;
        u.contractAddr = contractAddr;
        u.name = name;
        u.hashedPassword = keccak256(abi.encodePacked(password)); // Store the hashed password
        u.userId = userId;
        users[email] = u;
    }

    function getSmartContractAddress(bytes32 email) public view returns (address) {
        return users[email].contractAddr;
    }

    function getUser(bytes32 email) public view onlyOwner returns (User memory) {
        return users[email];
    }

    function isUserExist(bytes32 email) public view returns (bool) {
        return users[email].contractAddr != address(0);
    }

    function authenticate(bytes32 email, bytes32 password) public view onlyOwner returns (address) {
        require(
            users[email].hashedPassword == keccak256(abi.encodePacked(password)),
            "Invalid User"
        );
        return users[email].contractAddr;
    }
}
