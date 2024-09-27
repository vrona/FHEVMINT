//SPDX-License-Identifier: proprietary

pragma solidity ^0.8.19;

import { IOperation } from "./IOperation.sol";
import { IGeoInt } from "./IGeoInt.sol";
import { IHumInt } from "./IHumInt.sol";

interface IOpMetadata {
    function basicOpMetadata(IOperation.OperationData memory _operationData) external pure returns (string memory);
    function geoIntMetadata(IGeoInt.UAVSource memory _uavData) external pure returns (string memory);
    function humIntMetadata(IHumInt.HSource memory _humanData) external pure returns (string memory);
}
