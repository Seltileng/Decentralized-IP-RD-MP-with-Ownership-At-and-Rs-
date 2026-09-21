// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IPFSStorage
/// @notice Stores and retrieves IPFS content identifiers (CIDs) on-chain.
contract IPFSStorage {
    struct FileRecord {
        string cid;
        string name;
        uint256 timestamp;
    }

    mapping(address => FileRecord[]) private filesByOwner;

    event FileStored(
        address indexed owner,
        uint256 indexed fileId,
        string cid,
        string name
    );

    error EmptyCID();
    error InvalidFileId();

    function storeFile(string calldata cid, string calldata name)
        external
        returns (uint256 fileId)
    {
        if (bytes(cid).length == 0) revert EmptyCID();

        fileId = filesByOwner[msg.sender].length;
        filesByOwner[msg.sender].push(
            FileRecord({cid: cid, name: name, timestamp: block.timestamp})
        );

        emit FileStored(msg.sender, fileId, cid, name);
    }

    function getFile(address owner, uint256 fileId)
        external
        view
        returns (FileRecord memory)
    {
        if (fileId >= filesByOwner[owner].length) revert InvalidFileId();
        return filesByOwner[owner][fileId];
    }

    function getFiles(address owner)
        external
        view
        returns (FileRecord[] memory)
    {
        return filesByOwner[owner];
    }

    function getFileCount(address owner) external view returns (uint256) {
        return filesByOwner[owner].length;
    }
}
