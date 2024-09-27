//SPDX-License-Identifier: proprietary
pragma solidity ^0.8.19;

import "fhevm/lib/TFHE.sol";

interface IHumInt {
    enum JobCategory {
        Agriculture,
        Art,
        Business,
        Education,
        Engineering,
        Entertainment,
        Government,
        Healthcare,
        Information,
        Law,
        Military,
        ServiceIndustry,
        Science,
        Trades,
        Transportation
    }

    enum ActTowardTarget {
        Dormant,
        Listening,
        Contact
    }

    enum TargetPriority {
        Low,
        Mid,
        High
    }

    enum TargetType {
        Civil,
        Government,
        Military
    }

    enum CampType {
        Fellow,
        Ally,
        Neutral,
        Enemy
    }

    enum IntelStatus {
        NoneInfiltrate,
        InformantInfiltrate,
        InformantStandAlone,
        InformantPotential
    }

    enum HealthStatus {
        Active,
        Wounded,
        Dead
    }

    struct HSource {
        uint256 operationTokenId; // #fhEVM
        uint256 missionTokenId; // #fhEVM
        address sourceId; // OfficerAddress
        string humansourcename; // Name Surname aka
        CampType campType;
        TargetType targettype;
        JobCategory targetactivity;
        IntelStatus intelstatus;
        HealthStatus healthstatus;
        ActTowardTarget acttowardsource;
        uint256 targetid;
        uint256[] ascendid;
        uint64 localization; // LATLONG SHOULD BE euint4 not euint32
        string[] arrayofcontent; // reports, pictures, videos.
    }
}
