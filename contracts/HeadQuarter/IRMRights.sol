//SPDX-License-Identifier: proprietary

pragma solidity ^0.8.19;

import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

// NOT DEFINITIVE NEEDS TO ADD THE INPUT OF KECCAK
contract IRMRights is AccessControl {
    // rank
    bytes32 constant majorRANK = keccak256("MAJOR_RANK");
    bytes32 constant intelOfficerRANK = keccak256("INTEL_OFFICER_RANK");
    bytes32 constant opxOperatorRANK = keccak256("OPX_OPERATOR_RANK");

    // accredidation
    bytes32 constant topsecretACCRE = keccak256("TOPSECRET_ACCRE");
    bytes32 constant secretACCRE = keccak256("SECRET_ACCRE");
    bytes32 constant confidentialACCRE = keccak256("CONFIDENTIAL_ACCRE");

    constructor() {
        // set admin role for each role
        _setRoleAdmin(majorRANK, DEFAULT_ADMIN_ROLE);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(majorRANK, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setConfidentialAcc(address _personnel) public onlyRole(majorRANK) {
        grantRole(confidentialACCRE, _personnel);
    }

    function setSecretAcc(address _personnel) public onlyRole(majorRANK) {
        grantRole(secretACCRE, _personnel);
    }

    function setTopSecretAcc(address _personnel) public onlyRole(majorRANK) {
        grantRole(topsecretACCRE, _personnel);
    }

    function setMajorRank(address _personnel) public onlyRole(majorRANK) {
        grantRole(majorRANK, _personnel);
    }

    function setIntelOfficerRank(address _personnel) public onlyRole(majorRANK) {
        grantRole(intelOfficerRANK, _personnel);
    }

    function setOpxOperatorRank(address _personnel) public onlyRole(majorRANK) {
        grantRole(opxOperatorRANK, _personnel);
    }
}
