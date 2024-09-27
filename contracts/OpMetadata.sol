//SPDX-License-Identifier: proprietary

pragma solidity ^0.8.19;

import { IRMHelper } from "./IRMHelper.sol";
import { IOperation } from "./interfaces/IOperation.sol";
import { IGeoInt } from "./interfaces/IGeoInt.sol";
import { IHumInt } from "./interfaces/IHumInt.sol";

contract OpMetadata is IOperation {
    function basicOpMetadata(OperationData memory _operationData) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "Campaign:\n",
                    "basicID:",
                    IRMHelper.uint2str(_operationData.opTokenId),
                    "\n",
                    // "Existence:",
                    // IRMHelper.uint2str(uint256(_operationData.existence)),
                    // "\n",
                    "Name:",
                    _operationData.name,
                    "\n",
                    "SecretClassification:",
                    IRMHelper.uint2str(uint256(_operationData.secretclass)),
                    "\n",
                    "Commanding Officer:",
                    _operationData.commandername,
                    "\n"
                    // "Engaging Units:",
                    // _operationData.collectionOfSources,
                    // "\n",
                    // "Report:",
                    // _operationData.
                )
            );
    }

    function geoIntMetadata(IGeoInt.UAVSource memory _uavData) public pure returns (string memory) {
        return string(abi.encodePacked());
    }
    // function advancedOpMetadata(OperationData memory _operationData) public pure returns (string memory) {
    //     return
    //         string(
    //             abi.encodePacked(
    //                 "Key:",
    //                 _operationData.operationKey,
    //                 "\n",
    //                 "\n",
    //                 "Start Date:",
    //                 _operationData.startDate,
    //                 "\n",
    //                 "Active:",
    //                 _operationData.operationActive,
    //                 "\n",
    //                 "Engaging Units:",
    //                 _operationData.collectionOfSources,
    //                 "\n",
    //                 "Campaign Report:",
    //                 _operationData.linkOfReport
    //             )
    //         );
    // }

    function humIntMetadata(IHumInt.HSource memory _humanData) public pure returns (string memory) {
        return string(abi.encodePacked());
    }
}
