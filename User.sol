// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Patient{

    address public owner;

    bytes publicKey;
    bytes privateKey;

    struct request{
        address doctor_id;
        bytes32 doctor_name;
        bytes32 file_name;
        bool approve;
    }
    
    mapping(bytes32 => bytes) files;
    bytes32[] file_names;
    
    mapping(bytes32 => request[]) requests;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Owner required");
        _;
    }

    function addData(bytes32 file_name, bytes memory ipfsaddress) public onlyOwner{
        file_names.push(file_name);   
        files[file_name] = ipfsaddress;     
       
    }

    function addKeys(bytes memory pk, bytes memory pr) public {
        publicKey = pk;
        privateKey = pr;
    }

    function getPublicKey() view public returns (bytes memory){
        return publicKey;
    }

    function getPrivateKey() view public onlyOwner returns (bytes memory) {
        return privateKey;
    }

    function getFileNames() public view returns (bytes32[] memory){
        return file_names;
    }

    function getFileHash(bytes32 fname) view public returns (bytes memory){
        return files[fname];
    }

    function changeFileHash(bytes32 fname, bytes memory fileHash) public{
        files[fname] = fileHash;        
    }

    function sendRequest(address doctor_id, bytes32 file_name, bytes32 doctor_name, bytes32 doctor_email) public{
        request memory r;
        r.doctor_id = doctor_id;
        r.file_name = file_name;
        r.doctor_name = doctor_name;
        r.approve = false;
        request[] storage re = requests[doctor_email];
        re.push(r);
    }

    function getRequests(bytes32 d_email) public view returns (request[] memory){
        return requests[d_email];
    }

    function approveRequest(bytes32 d_email, bytes32 file_name) public onlyOwner{
        request[] storage re = requests[d_email];
        for(uint i = 0; i < re.length; i++){
            if(re[i].file_name == file_name){
                re[i].approve = true;
                break;
            }
        }
    }

}