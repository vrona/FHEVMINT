//SPDX-License-Identifier: proprietary
pragma solidity ^0.8.19;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { IOpMetadata } from "../interfaces/IOpMetadata.sol";
import { IOperation } from "../interfaces/IOperation.sol";
import { IHQBase } from "../interfaces/IHQBase.sol";
import { IHumInt } from "../interfaces/IHumInt.sol";
import { IEngine } from "../interfaces/IEngine.sol";
import { IRMRights } from "../HeadQuarter/IRMRights.sol";
import "fhevm/lib/TFHE.sol";

contract HumInt is ERC721, ERC721URIStorage, IHumInt, IRMRights {
    IOpMetadata METADATA;
    IHQBase HQBase;
    IEngine Engine;

    IHumInt.HSource[] internal humIntSource; // struct of UAV sources data
    mapping(uint256 => uint256) opTokenToMissionToken; // Operation NFT tokenId to Mission NFT tokenId
    mapping(uint256 => euint32) missionTokenToKey; // GeoInt NFT tokenId to Mission encryption key

    modifier onlyIntelOpx() {
        require(
            hasRole(intelOfficerRANK, msg.sender) || hasRole(opxOperatorRANK, msg.sender),
            "Access denied, see Major."
        );
        _;
    }

    modifier onlyMajorIntelOfficer() {
        require(hasRole(majorRANK, msg.sender) || hasRole(intelOfficerRANK, msg.sender), "Access denied, see Major.");
        _;
    }
    constructor(IOpMetadata _opMetadata, IHQBase hqbase, IEngine engine) ERC721("Human Intelligence", "HUMINT") {
        METADATA = _opMetadata;
        HQBase = hqbase;
        Engine = engine;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, ERC721URIStorage, IRMRights) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function missionTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _setTokenURI(tokenId, _tokenURI);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // NFT mission creation (mint) CAN ONLY BE if operationActiveCheck() is true (Major must have share the Mission's Active Code).
    function createMission(address operationAddress, uint256 operationTokenId) public onlyRole(intelOfficerRANK) {
        uint8 unitEngaged = HQBase.getUnitEngaged(operationAddress, operationTokenId);
        require(Engine.focusOnUnitEngagement(unitEngaged, 0), "Unit not engaged"); // 0 is indice of HUMINT
        uint256 missiontokenID = humIntSource.length;

        addMission(operationTokenId, missiontokenID, msg.sender);
        mintMission(missiontokenID);
        opTokenToMissionToken[operationTokenId] = missiontokenID;
        addSourceToOp(operationAddress, operationTokenId, missiontokenID);
    }

    // add mission token Id to central database : HQBase
    function addSourceToOp(address operationAddress, uint256 opTokenId, uint256 missionTokenId) public {
        HQBase.addSourceTokenId(operationAddress, opTokenId, 0, missionTokenId); // 0 is indice of HUMINT
    }

    // mint the Mission NFT
    function mintMission(uint256 missiontokenID) internal {
        _mint(msg.sender, missiontokenID);
        string memory makeTokenURI = serializeUri(humIntSource[missiontokenID]);
        missionTokenURI(missiontokenID, makeTokenURI);
    }

    function serializeUri(HSource memory _humanData) internal view returns (string memory) {
        string memory newTokenURI = METADATA.humIntMetadata(_humanData);
        return newTokenURI;
    }

    function addMission(uint256 operationTokenId, uint256 missionTokenId, address officerID) internal {
        humIntSource.push(newMission(operationTokenId, missionTokenId, officerID));
    }

    function newMission(
        uint256 operationTokenId,
        uint256 _missiontokenID,
        address officerID
    ) internal view onlyRole(intelOfficerRANK) returns (HSource memory metamission) {
        metamission.operationTokenId = operationTokenId;
        metamission.missionTokenId = _missiontokenID;
        metamission.sourceId = officerID;
        return metamission;
    }

    // transfert Mission to other Officer or Operator
    function transferMission(address from, address to, uint256 missionTokenId) public onlyIntelOpx {
        transferFrom(from, to, missionTokenId);
    }

    // ENCRYPT
    // missionKey #Front add
    function mission_Key(uint256 missionTokenId, bytes calldata keytoencrypt) internal onlyRole(intelOfficerRANK) {
        storeMissionKey(missionTokenId, TFHE.asEuint32(keytoencrypt));
    }

    function storeMissionKey(uint256 missionTokenId, euint32 missionCipherKEY) internal {
        missionTokenToKey[missionTokenId] = missionCipherKEY;
    }

    function humanTargetLocation(uint256 missionTokenId, uint64 localization) internal onlyIntelOpx {
        humIntSource[missionTokenId].localization = localization;
    }

    function arrayOfContent(uint256 missionTokenId, string memory linkofcontent) internal onlyIntelOpx {
        humIntSource[missionTokenId].arrayofcontent.push(linkofcontent);
    }

    /// Retrieve data to HumInt Sources
    function getMissionData(uint256 missionTokenId) public view onlyIntelOpx returns (HSource memory) {
        require(ownerOf(missionTokenId) == msg.sender, "Not the owner.");
        return humIntSource[missionTokenId];
    }

    function getEncryptionKey(uint256 missionTokenId) public view onlyIntelOpx returns (euint32) {
        require(ownerOf(missionTokenId) == msg.sender, "Not the owner.");
        return missionTokenToKey[missionTokenId];
    }
}
