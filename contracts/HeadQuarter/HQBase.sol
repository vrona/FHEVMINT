//SPDX-License-Identifier: proprietary

pragma solidity ^0.8.19;

import { IRMRights } from "./IRMRights.sol";
import "fhevm/lib/TFHE.sol";
import "fhevm/gateway/GatewayCaller.sol";
import { IOperation } from "../interfaces/IOperation.sol";
import { IEngine } from "../interfaces/IEngine.sol";

abstract contract HQBase is IRMRights, GatewayCaller {
    IEngine Engine;

    ebool isCodeEqual; // Code UI to trigger Mission Creation Button

    struct SourceCollection {
        euint16 operationCodeActive;
        uint8 intelUnitEngaged;
        mapping(uint256 => uint256[]) sourceArray; // 0 humint, 1 sigint, 2 geoint, 3 cybint, 4 osint, 5 masint, 6 finint, 7 imint
    }
    // Principle
    /*
    Stores all Operations and Missions

    Human sources
    */
    //_contextSuffixLengthIOperation.SourceCollection opSourceCollection;

    // retrieve NFT OPERATION - Address MISSION NFT ARRAYS
    mapping(address => address[]) mapOperationAddressToMissionAddress;
    euint16[] internal humansources;

    // store all operation contract in array;
    address[] public arrayOfOperation;

    // store uint8 UnitEngaged for each Op Token Id of a given Op Contract fromOpAddrToUnitEngaged[OpFactory][OperationTokenID]
    // mapping(address => mapping(uint256 => uint8)) fromOpAddrToUnitEngaged;

    // store struct SourceCollection for a given Operation TokenId of a given Operation Contract mapOpToSourceCollection[OperationContractAddress][OperationTokenID]
    mapping(address => mapping(uint256 => SourceCollection)) mapOpToSourceCollection;
    // store Op Add to Mission Add
    // mapping(address => address[]) operationToMission;

    modifier onlyMajorIntelOfficer() {
        require(hasRole(majorRANK, msg.sender) || hasRole(intelOfficerRANK, msg.sender), "Access denied, see Major.");
        _;
    }

    // events to enable or not the mint.
    // event isActivated();
    // event isUnActivated();

    constructor(IEngine engine) {
        Engine = engine;
    }

    // Needs to implement Input Code UI to trigger Mission Creation Button
    function operationActiveCheck(
        address operationAddress,
        uint256 opTokenId,
        euint16 codeSuggested
    ) internal returns (ebool) {
        euint16 opCodeActive = getActiveOperation(operationAddress, opTokenId);
        isCodeEqual = TFHE.eq(opCodeActive, codeSuggested);
        TFHE.allow(isCodeEqual, address(this));
        TFHE.allow(isCodeEqual, msg.sender);
        //bool isLaunchActivated = opActiveCheckCallBack(); //TFHE.decrypt(isCodeEqual);
        // uint256[] memory cts = new uint256[](1);
        // cts[0] = Gateway.toUint256(isCodeEqual);
        // Gateway.requestDecryption(cts, this.opActiveCheckCallBack.selector, 0, block.timestamp + 100, false);

        // // if (isLaunchActivated) {
        // //     emit isActivated();
        // // } else {
        // //     emit isUnActivated();
        // // }
        return isCodeEqual;
    }

    function addOperationToArray(address operationAddress) public onlyRole(majorRANK) {
        arrayOfOperation.push(operationAddress);
    }

    function getOperationAddr(uint256 index) public view onlyRole(majorRANK) returns (address) {
        return arrayOfOperation[index];
    }

    function addADDRMissionToOperation(address operationAddress, address missionAddress) public onlyMajorIntelOfficer {
        mapOperationAddressToMissionAddress[operationAddress].push(missionAddress);
    }

    /**
     * @notice About struct SourceCollection
     */

    // add intelUnitEngaged
    function addIntelUnitEngaged(
        address operationAddress,
        uint256 opTokenId,
        uint8 intelUnitEngaged
    ) public onlyRole(majorRANK) {
        mapOpToSourceCollection[operationAddress][opTokenId].intelUnitEngaged = intelUnitEngaged;
    }

    // get source collection hashes from struct SourceCollection
    function getIntelUnitEngaged(
        address operationAddress,
        uint256 opTokenId
    ) public view onlyRole(majorRANK) returns (uint8) {
        return mapOpToSourceCollection[operationAddress][opTokenId].intelUnitEngaged;
    }

    // add a Secret code indicating operation Active status
    function addOpCodeActive(
        address operationAddress,
        uint256 opTokenId,
        euint16 opCodeActive
    ) public onlyMajorIntelOfficer {
        mapOpToSourceCollection[operationAddress][opTokenId].operationCodeActive = opCodeActive;
    }

    // get the Secret code indicating operation Active status
    function getOpCodeActive(
        address operationAddress,
        uint256 opTokenId
    ) public view onlyMajorIntelOfficer returns (euint16) {
        return mapOpToSourceCollection[operationAddress][opTokenId].operationCodeActive;
    }

    // get active operation list
    function getActiveOperation(
        address operationAddress,
        uint256 operationID
    ) private view onlyMajorIntelOfficer returns (euint16) {
        euint16 operationCheck = HQBase.getOpCodeActive(operationAddress, operationID);
        return operationCheck;
    }

    // add Mission TokenId to SourceCollection struct
    function addMissionTokenIdToSource(
        address operationAddress,
        uint256 opTokenId,
        uint8 source,
        uint256 missionTokenId
    ) public onlyMajorIntelOfficer {
        // current SourceCollection
        uint8 unitEngaged = mapOpToSourceCollection[operationAddress][opTokenId].intelUnitEngaged;

        // checking unit engagement bool
        if (Engine.focusOnUnitEngagement(unitEngaged, source)) {
            // if true store the mission token id.
            mapOpToSourceCollection[operationAddress][opTokenId].sourceArray[source].push(missionTokenId);
        }
    }

    // get all the missions' tokenId's of a source for a given Operation Address, Operation Token Id
    function getMissionTokenIdOfSource(
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
