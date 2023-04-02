// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

struct User{
    bytes32 role;
    address contract_addr;
    bytes32 name;
    bytes32 password;
    address user_id;
}
contract Authorization{
    address public owner;
    mapping(bytes32 => User) user;

    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner, "Admin required");
        _;
    }
    function addUser(address contract_addr, bytes32 role, bytes32 name, bytes32 email, bytes32 password, address user_id) public onlyOwner{
        User memory u;
        u.role = role;
        u.contract_addr = contract_addr;
        u.name = name;
        u.password = password;
        u.user_id = user_id;
        user[email] = u;
    }
    function getSC_Hash(bytes32 email) view public returns (address){
        return user[email].contract_addr;
    }
    function getUser(bytes32 email) view public returns (User memory)
    {
        return user[email];
    }
    function isUserExist(bytes32 email) view public returns (address)
    {
        return user[email].contract_addr;
    }
    function authenticate(bytes32 email, bytes32 password) view public onlyowner returns (address){
        require(user[email].password == password, "Invalid User");
        return user[email].contract_addr;
    }
   
}