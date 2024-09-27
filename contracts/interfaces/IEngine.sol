//SPDX-License-Identifier: proprietary
pragma solidity ^0.8.19;

import "fhevm/lib/TFHE.sol";
import "fhevm/gateway/GatewayCaller.sol";

interface IEngine {
    struct LatLong {
        uint32 latitude; // single-precision float
        uint32 longitude; // single-precision float
    }

    function hashOfSlot32(uint8 slot, uint32 datatostore) external pure returns (uint32);
    function hashOfSlot64(uint8 slot, uint64 datatostore) external pure returns (uint64);
    function hashOfSlot256(uint8 slot, uint256 datatostore) external pure returns (uint256);
    function initSourcesCollectHash(uint8 code) external pure returns (uint64);
    function focusOnUnitEngagement(uint8 unitEngaged, uint8 slot) external pure returns (bool);
    //TOBEDEL function locationHashing(IHQBase.LatLong memory gps) external pure returns (uint64);
    //function decodeUnitEngaging(uint8 code) external pure returns (IHQBase.SourcesUnit memory units);
    //function unitCollectHashing(IHQBase.SourcesUnit memory unit) external pure returns (uint64);
}
