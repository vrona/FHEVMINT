//SPDX-License-Identifier: proprietary
pragma solidity ^0.8.19;

import "fhevm/lib/TFHE.sol";

interface ISigInt {
    enum Importancelevel {
        Low,
        Middle,
        High
    }

    struct DSource {
        address sourceid; // OfficerAddress
        string missionKey;
        uint256 belongsto; // cf. IHuman targetid
        Importancelevel importantlevel;
        string[] linkofcontent; // reports, pictures, videos.
    }
}
