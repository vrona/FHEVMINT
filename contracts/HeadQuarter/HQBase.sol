//SPDX-License-Identifier: proprietary

pragma solidity ^0.8.19;

import { IRMRights } from "./IRMRights.sol";
import "fhevm/lib/TFHE.sol";
import { IOperation } from "../interfaces/IOperation.sol";
import { IEngine } from "../interfaces/IEngine.sol";

abstract contract HQBase is IRMRights {
    IEngine Engine;

    struct SourceCollection {
        euint16 operationCodeActive;
        uint8 unitengaged;
        mapping(uint256 => uint256[]) sourceArray; // 0 humint, 1 sigint, 2 geoint, 3 cybint, 4 osint, 5 masint, 6 finint, 7 imint
    }
    // Principle
    /*
    Stores all Operations and Missions

    Human sources
    */
    //_contextSuffixLengthIOperation.SourceCollection opSourceCollection;
    // retrieve NFT OPERATION - Address MISSION NFT ARRAYS
    mapping(address => address[]) mapOpAddrToMissAddr;
    euint16[] internal humansources;

    // store all operation contract in array;
    address[] public arrayOfOperation;
    // store all operation tokenId for each operation contract
    mapping(address => uint256) mapOpAddrToOpTokenID;

    // store uint8 UnitEngaged for each Op Token Id of a given Op Contract fromOpAddrToUnitEngaged[OpFactory][OperationTokenID]
    // mapping(address => mapping(uint256 => uint8)) fromOpAddrToUnitEngaged;

    // store struct SourceCollection for a given Op TokenId of a given Op Contract mapOpToSourceCollection[OperationContractAddress][OperationTokenID]
    mapping(address => mapping(uint256 => SourceCollection)) mapOpToSourceCollection;
    // store Op Add to Mission Add
    // mapping(address => address[]) operationToMission;

    modifier onlyMajorIntelOfficer() {
        require(hasRole(majorRANK, msg.sender) || hasRole(intelOfficerRANK, msg.sender), "Access denied, see Major.");
        _;
    }

    // events to enable or not the mint.
    event isActivated();
    event isUnActivated();

    constructor(IEngine engine) {
        Engine = engine;
    }

    // Needs to implement Input Code UI to trigger Mission Creation Button
    function operationActiveCheck(address operationAddress, uint256 opTokenId, euint16 codeSuggested) internal {
        euint16 opCodeActive = getActiveOperation(operationAddress, opTokenId);
        ebool isCodeEqual = TFHE.eq(opCodeActive, codeSuggested);
        bool isLaunchActivated = TFHE.decrypt(isCodeEqual);
        if (isLaunchActivated) {
            emit isActivated();
        } else {
            emit isUnActivated();
        }
    }

    function addOperationAddr(address operationAddress) public onlyRole(majorRANK) {
        arrayOfOperation.push(operationAddress);
    }

    function getOperationAddr(uint256 index) public view onlyRole(majorRANK) returns (address) {
        return arrayOfOperation[index];
    }

    function addADDRMissToOp(address operationAddress, address missionAddress) public onlyMajorIntelOfficer {
        mapOpAddrToMissAddr[operationAddress].push(missionAddress);
    }

    /**
     * @notice About struct SourceCollection
     */

    // add unitengaged
    function addUnitEngaged(address operationAddress, uint256 opTokenId, uint8 unitengaged) public onlyRole(majorRANK) {
        mapOpToSourceCollection[operationAddress][opTokenId].unitengaged = unitengaged;
    }

    // get source collection hashes from struct SourceCollection
    function getUnitEngaged(
        address operationAddress,
        uint256 opTokenId
    ) public view onlyRole(majorRANK) returns (uint8) {
        return mapOpToSourceCollection[operationAddress][opTokenId].unitengaged;
    }

    function addOpCodeActive(
        address operationAddress,
        uint256 opTokenId,
        euint16 opCodeActive
    ) public onlyMajorIntelOfficer {
        mapOpToSourceCollection[operationAddress][opTokenId].operationCodeActive = opCodeActive;
    }

    function getOpCodeActive(
        address operationAddress,
        uint256 opTokenId
    ) public view onlyMajorIntelOfficer returns (euint16) {
        return mapOpToSourceCollection[operationAddress][opTokenId].operationCodeActive;
    }

    function getActiveOperation(
        address operationAddress,
        uint256 operationID
    ) private view onlyMajorIntelOfficer returns (euint16) {
        euint16 operationCheck = HQBase.getOpCodeActive(operationAddress, operationID);
        return operationCheck;
    }

    // add Mission TokenId to SourceCollection struct
    function addSourceTokenId(
        address operationAddress,
        uint256 opTokenId,
        uint8 source,
        uint256 missionTokenId
    ) public onlyMajorIntelOfficer {
        // current SourceCollection
        uint8 unitEngaged = mapOpToSourceCollection[operationAddress][opTokenId].unitengaged;

        // checking unit engagement bool
        if (Engine.focusOnUnitEngagement(unitEngaged, source)) {
            // if true store the mission token id.
            mapOpToSourceCollection[operationAddress][opTokenId].sourceArray[source].push(missionTokenId);
        }
    }

    function getSourceTokenId(
        address operationAddress,
        uint256 opTokenId,
        uint8 source
    ) public view returns (uint256[] memory) {
        return mapOpToSourceCollection[operationAddress][opTokenId].sourceArray[source];
    }
}

/*
 // checking unit engagement bool
if (Engine.focusOnUnitEngagement(unitEngaged, slot)) {
    // if true
    // get existing source collect hash and add current mission token Id
    currentSourceHash += Engine.hashOfSlot64(slot, missionTokenId);
    // store SourceHash
    mapOpToSourceCollection[operationAddress][opTokenId].sourcesCollectHash = currentSourceHash;
} else {
    // if false, 0 tokenId and storing SourceHash
    currentSourceHash += Engine.hashOfSlot64(slot, 0);
    mapOpToSourceCollection[operationAddress][opTokenId].sourcesCollectHash = currentSourceHash;
}
*/
