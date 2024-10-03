//SPDX-License-Identifier: proprietary
pragma solidity ^0.8.19;

import "fhevm/lib/TFHE.sol";

interface IGeoInt {
    struct SourceOrigin {
        uint16 satellite;
        uint16 uav;
    }
    enum TerrainType {
        Mountain,
        Desert,
        Forest,
        Grassland,
        Urban,
        River,
        Lake,
        Sea
    }

    struct BuildingType {
        // Residential
        uint8 residential;
        // Commercial
        uint8 offices;
        uint8 retailStore;
        uint8 restaurant;
        uint8 hotel;
        // Institutional
        uint8 hospital;
        uint8 government;
        uint8 school;
        // Industrial
        uint8 warehouse;
        uint8 factory;
        uint8 fuelTank;
        uint8 pipeline;
        // Agricultural
        uint8 farm;
        uint8 silos;
        // Infrastructure
        uint8 airport;
        uint8 stadium;
        uint8 bridge;
        uint8 tunnel;
        uint8 airstrip;
        uint8 rail;
        uint8 railStation;
        uint8 dam;
        uint8 port;
        // Military
        uint8 barracks;
        uint8 base;
    }

    struct CivilianEquipment {
        uint8 largeCommercialAircraft;
        uint8 smallCommercialAircraft;
        uint8 cargoAircraft;
        uint8 commercialTrain;
        uint8 cargoTrain;
        uint8 lightVehicle;
        uint8 utilityVehicle;
        uint8 bus;
        uint8 truck;
        uint8 motorcycle;
        uint8 bicycle;
        uint8 boat;
    }

    // struct MilitaryEquipmentDefense {
    //     uint8 combatAircraft;
    //     uint8 radarAircraft;
    //     uint8 boat;
    //     uint8 submarine;
    //     uint8 roadCheckPoint;
    //     uint8 antiAirThreat;
    //     uint8 antiShip;
    //     uint8 antiSubmarine;
    // }

    struct LatLong {
        uint32 latitude; // single-precision float
        uint32 longitude; // single-precision float
    }

    /* here the UAVSource contains
    - data of Operation + mission + officer Id + hardware Id
    - data which can be encrypted and then on which HE can be done (updated by others Intel Unit or Field Unit)
    - storage of contents
    */
    struct UAVSource {
        uint256 operationTokenId; // #fhEVM
        uint256 missionTokenId; // #fhEVM
        address sourceId; // OfficerAddress // #fhEVM
        uint256 uavOrigin; // from SourceOrigin struct + identification number #AES
        uint256 building; // from Buildingtype struct                          #AES
        uint256 civilianEquipment; // from CivilianEquipment struct            #AES
        euint32 militaryEquipDef; // SHOULD BE euint64 not euint32 from MilitaryEquipment + MilitaryDefenseType structs #fhEVM
        uint256 personnel; // #AES
        uint64 localization; // LATLONG SHOULD BE euint64 not euint32
        string[] arrayofcontent; // pictures, videos.
    }
}
