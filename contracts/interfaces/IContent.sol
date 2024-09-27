//SPDX-License-Identifier: proprietary
pragma solidity ^0.8.19;

import "fhevm/lib/TFHE.sol";

interface IContent {
    enum DeviceType {
        Satellite,
        uav,
        phone,
        camera,
        vehicle
    }

    enum Importancelevel {
        Low,
        Middle,
        High
    }

    struct Video {
        string title;
        string description;
        string language;
        uint256[] humaninvolve; // cf. IHuman targetid
        Importancelevel importancelevel;
        DeviceType devicetypeorigin;
        uint256 deviceid;
        uint256 datetime;
        uint256 location;
        string linktovideo;
    }

    struct Photo {
        string title;
        string description;
        uint256[] humaninvolve; // cf. IHuman targetid
        Importancelevel importancelevel;
        DeviceType devicetypeorigin;
        uint256 deviceid;
        uint256 datetime;
        uint256 location;
        string linktophoto;
    }

    struct Text {
        string title;
        string description;
        string language;
        uint256 authorid; // cf. IHuman targetid
        Importancelevel importancelevel;
        DeviceType devicetypeorigin;
        uint256 deviceid;
        uint256 datetime;
        uint256 location;
        string linktotext;
    }
}
