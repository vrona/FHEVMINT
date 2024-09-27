//SPDX-License-Identifier: proprietary

pragma solidity ^0.8.19;

import "fhevm/lib/TFHE.sol";
import { IHQBase } from "./IHQBase.sol";

interface IOperation {
    enum SecretClassification {
        Confidential,
        Secret,
        TopSecret
    }

    struct TestOpData {
        uint256 opTokenId;
        string name;
        SecretClassification secretclass;
        string commandername;
    }

    struct OperationData {
        uint256 opTokenId; // automated from blockchain - back
        string name; // typed on front page - clear
        SecretClassification secretclass; // typed on front page - clear
        string commandername; // typed on front page - clear
        uint8 unitengaged; // 8bits number
        string[] arrayOfReport; // typed on front page - encrypted (Goal, Assessment, Key Targets, Post)
        // OpCreation existence; // automated from blockchain - back
        // euint32 startDate; // typed on front page - encrypted
        // euint8 operationActive; // typed on front page - encrypted
    }

    // struct OperationDataReencrypt {
    //     uint256 opTokenId; // automated from blockchain - back
    //     // OpCreation existence;    // automated from blockchain - back
    //     string name; // typed on front page - clear
    //     SecretClassification secretclass; // typed on front page - clear
    //     string commandername; // typed on front page - clear
    //     bytes operationKey; // client generated on front page - encrypted
    //     // bytes startDate;         // typed on front page - encrypted
    //     // bytes operationActive;   // typed on front page - encrypted
    //     bytes collectionOfSources; // 64584855 (incl. the tokenID of each NFT mission + Units Engaged 101101)
    //     string linkOfReport; // typed on front page - encrypted (Goal, Assessment, Key Targets, Post)
    // }
}
