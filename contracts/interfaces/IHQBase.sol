//SPDX-License-Identifier: proprietary
pragma solidity ^0.8.19;

import "fhevm/lib/TFHE.sol";

interface IHQBase {
    enum MilitaryOPSType {
        SpecialForces,
        Infantry,
        Armored,
        Engineering,
        NavalSpecialOps,
        FighterSquadron,
        AerialReconnaissance,
        SearchAndRescue
    }

    // about storage
    function addOperationToArray(address operationAddress) external;
    function getOperationAddr(uint256 index) external view returns (address);
    function addADDRMissionToOperation(address operationAddress, address missionAddress) external;
    // about struct Source Collection
    function addIntelUnitEngaged(address operationAddress, uint256 opTokenId, uint8 unitengaged) external;
    function getIntelUnitEngaged(address operationAddress, uint256 opTokenId) external view returns (uint8 unitengaged);
    function addOpCodeActive(address operationAddress, uint256 opTokenId, euint16 opCodeActive) external;
    function getOpCodeActive(address operationAddress, uint256 operationID) external view returns (euint16);
    function addMissionTokenIdToSource(
        address operationAddress,
        uint256 opTokenId,
        uint8 slot,
        uint256 missionTokenId
    ) external;
    function getSourceHashSlot(address operationAddress, uint256 opTokenId) external view returns (uint64);
    function getMissionTokenIdOfSource(
        address operationAddress,
        uint256 opTokenId,
        uint8 source
    ) external view returns (uint256[] memory);
}

/*
>> Human Intelligence (HUMINT): IHuman.sol
Information gathered from human sources, such as informants, agents, defectors, or diplomats.
Provides insights into intentions, capabilities, and activities of individuals, groups, or governments.

>> Signals Intelligence (SIGINT):
Collection and analysis of intercepted electronic communications, including radio transmissions, emails, phone calls, and internet traffic.
Helps uncover patterns, networks, and communications among targets of interest.

Open-Source Intelligence (OSINT):
Gathering and analyzing information from publicly available sources such as news articles, social media, government reports, academic papers, and public databases.
Provides a broad range of data to support analysis and decision-making.

>> Geospatial Intelligence (GEOINT): IUAV.sol
Gathering, analysis, and visualization of geospatial data, including satellite imagery, aerial photography, maps, and geographic information systems (GIS).
Enables identification of geographical features, infrastructure, troop movements, and other spatial patterns.

Measurement and Signature Intelligence (MASINT):
Collection and analysis of physical and technical data, including radar signatures, thermal signatures, nuclear radiation, and chemical emissions.
Provides unique insights into activities, capabilities, and technologies beyond traditional intelligence sources.

>> Cyber Intelligence (CYBINT):
Collection and analysis of data related to cybersecurity threats, vulnerabilities, and exploits.
Focuses on monitoring and assessing cyber activities, attacks, and actors in cyberspace.

Financial Intelligence (FININT):
Collection and analysis of financial data, transactions, and patterns to identify illicit activities such as money laundering, terrorist financing, and economic espionage.
Helps disrupt illicit financial networks and trace the flow of funds.

Imagery Intelligence (IMINT):
Collection and analysis of visual imagery, including photographs, videos, and reconnaissance footage.
Provides visual insights into targets, infrastructure, activities, and environmental changes.
*/
