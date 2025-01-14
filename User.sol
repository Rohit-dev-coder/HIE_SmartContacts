// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Patient {
    address public owner;

    bytes publicKey;

    struct Request {
        address doctorId;
        bytes32 doctorName;
        bytes32 fileName;
        bool approved;
    }

    mapping(bytes32 => bytes) private files; // Made private for added security
    bytes32[] private fileNames;            // Private access control for file list
    mapping(bytes32 => Request[]) private requests;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Owner required");
        _;
    }

    function addData(bytes32 fileName, bytes memory ipfsAddress) public onlyOwner {
        fileNames.push(fileName);
        files[fileName] = ipfsAddress;
    }

    function setPublicKey(bytes memory pk) public onlyOwner {
        publicKey = pk;
    }

    function getPublicKey() public view returns (bytes memory) {
        return publicKey;
    }

    function getFileNames() public view onlyOwner returns (bytes32[] memory) {
        return fileNames;
    }

    function getFileHash(bytes32 fileName) public view onlyOwner returns (bytes memory) {
        return files[fileName];
    }

    function changeFileHash(bytes32 fileName, bytes memory fileHash) public onlyOwner {
        files[fileName] = fileHash;
    }

    function sendRequest(
        address doctorId,
        bytes32 fileName,
        bytes32 doctorName,
        bytes32 doctorEmail
    ) public {
        Request memory r;
        r.doctorId = doctorId;
        r.fileName = fileName;
        r.doctorName = doctorName;
        r.approved = false;
        requests[doctorEmail].push(r);
    }

    function getRequests(bytes32 doctorEmail) public view returns (Request[] memory) {
        return requests[doctorEmail];
    }

    function approveRequest(bytes32 doctorEmail, bytes32 fileName) public onlyOwner {
        Request[] storage re = requests[doctorEmail];
        for (uint256 i = 0; i < re.length; i++) {
            if (re[i].fileName == fileName) {
                re[i].approved = true;
                break;
            }
        }
    }
}
