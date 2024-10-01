//SPDX-License-Identifier: proprietary
pragma solidity ^0.8.19;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { IOpMetadata } from "../interfaces/IOpMetadata.sol";
import "fhevm/lib/TFHE.sol";
import { IOperation } from "../interfaces/IOperation.sol";
import { IHQBase } from "../interfaces/IHQBase.sol";
import { IRMRights } from "./IRMRights.sol";

contract OpFactory is ERC721, ERC721URIStorage, IOperation, IRMRights {
    IOpMetadata opMetadata;
    IHQBase HQBase;

    IOperation.OperationData[] internal metaOpData; // array of struct Operation Data
    mapping(uint256 => euint32) operationTokenToKey; // Operation NFT and encryption key

    event OpCreated(uint256 indexed _opTokenId, string opName);

    modifier onlyMajorIntelOfficer() {
        require(hasRole(majorRANK, msg.sender) || hasRole(intelOfficerRANK, msg.sender), "Access denied, see Major.");
        _;
    }

    constructor(IOpMetadata _opMetadata, IHQBase hqBase) ERC721("INTEL_OPS", "INOPS") {
        opMetadata = _opMetadata;
        HQBase = hqBase;
        HQBase.addOperationAddr(address(this)); // store this NFT Operation Factory
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, ERC721URIStorage, IRMRights) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function opTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _setTokenURI(tokenId, _tokenURI);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function createOperation(
        string memory opName,
        SecretClassification opSecretClass,
        string memory commander
    ) public onlyRole(majorRANK) {
        uint256 tokenID = metaOpData.length;
        SecretClassification newopSecretClass = SecretClassification(opSecretClass);
        addOperation(tokenID, opName, newopSecretClass, commander);
        mintOperation(tokenID);
        emit OpCreated(tokenID, opName);
    }

    // mint the NFT Operation
    function mintOperation(uint256 _opTokenId) internal {
        _mint(msg.sender, _opTokenId);
        string memory makeTokenURI = serializeUri(metaOpData[_opTokenId]);
        opTokenURI(_opTokenId, makeTokenURI);
    }

    function serializeUri(OperationData memory _opData) internal view returns (string memory) {
        string memory newTokenURI = opMetadata.basicOpMetadata(_opData);
        return newTokenURI;
    }

    function addOperation(
        uint256 opTokenId,
        string memory opName,
        SecretClassification opSecretClass,
        string memory commander
    ) internal {
        metaOpData.push(newOperation(opTokenId, opName, opSecretClass, commander));
    }

    function newOperation(
        uint256 _opTokenId,
        string memory _opName,
        SecretClassification opSecretClass,
        string memory _commandOfficer
    ) internal view onlyRole(majorRANK) returns (OperationData memory metaoperation) {
        metaoperation.opTokenId = _opTokenId;
        metaoperation.name = _opName;
        metaoperation.secretclass = opSecretClass;
        metaoperation.commandername = _commandOfficer;
        return metaoperation;
    }

    function secretClass(uint256 opTokenId, SecretClassification opSecretClass) internal onlyRole(majorRANK) {
        metaOpData[opTokenId].secretclass = opSecretClass;
    }

    // commandOfficer #Front modify
    function commanderName(uint256 opTokenId, string memory _commandOfficer) internal onlyRole(majorRANK) {
        metaOpData[opTokenId].commandername = _commandOfficer;
    }

    // Upload (AES Encrypted) Reports #Front modify
    function storeReports(uint256 opTokenId, string memory _linkOfReport) internal onlyRole(majorRANK) {
        metaOpData[opTokenId].arrayOfReport.push(_linkOfReport);
    }

    function storeUnitEngagement(uint256 opTokenId, uint8 _unitengaged) internal {
        metaOpData[opTokenId].unitengaged = _unitengaged;
        HQBase.addUnitEngaged(address(this), opTokenId, _unitengaged);
    }

    // ENCRYPT
    // operationKey #Front add
    // function opKey(uint256 opTokenId, bytes calldata keytoencrypt) internal onlyRole(majorRANK) {
    //     storeOpKey(opTokenId, TFHE.asEuint32(keytoencrypt));
    // }
    function opKey(uint256 opTokenId, einput keytoencrypt, bytes calldata inputProof) internal onlyRole(majorRANK) {
        storeOpKey(opTokenId, TFHE.asEuint32(keytoencrypt, inputProof));
    }

    function storeOpKey(uint256 opTokenId, euint32 operationCipherKEY) internal onlyRole(majorRANK) {
        operationTokenToKey[opTokenId] = operationCipherKEY;
    }

    // To Activate Operation
    function opSecretActive(
        uint256 opTokenId,
        einput codetoencrypt,
        bytes calldata inputProof
    ) internal onlyRole(majorRANK) {
        storeOpSecretActive(opTokenId, TFHE.asEuint16(codetoencrypt, inputProof));
    }

    function storeOpSecretActive(uint256 opTokenId, euint16 codeCipherKEY) internal onlyRole(majorRANK) {
        HQBase.addOpCodeActive(address(this), opTokenId, codeCipherKEY);
    }

    //collectionOfSources #Front add
    // function sourceOfCollection(uint256 opTokenId, bytes calldata collectionOfSources) internal {
    //     storeSourceOfCollection(opTokenId, TFHE.asEuint32(collectionOfSources));
    // }

    // function storeSourceOfCollection(uint256 opTokenId, euint32 _collectionOfSources) internal {
    //     metaOpData[opTokenId].collectionOfSources = _collectionOfSources;
    // }

    function getMetaOperation(uint256 opTokenId) public view onlyRole(majorRANK) returns (OperationData memory) {
        return metaOpData[opTokenId];
    }

    function transferOperation(address from, address to, uint256 opTokenId) public onlyRole(majorRANK) {
        transferFrom(from, to, opTokenId);
    }
}
