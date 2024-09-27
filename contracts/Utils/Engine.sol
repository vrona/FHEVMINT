//SPDX-License-Identifier: proprietary

pragma solidity ^0.8.19;

abstract contract Engine {
    /**
     * @notice hashes which store a value v (where v >= 0 and v < MaxBits), into slot s (where s >= 0 and s < MaxBits/8bits): v x (MaxBits ^ s) into B bits a given unit's variation (tokenIf of mission per unit) into a given slot. To
     * @param slot each slot (slot 0 for unit a, slot b for unit b,...) is 1 byte (8-bits) which can store a _tokenID of this unit.
     * @param datatostore of a unit (= trait) is of value from to 1 to MaxBits-1
     * @return unithash MaxBits bit
     */

    function hashOfSlot256(uint8 slot, uint256 datatostore) internal pure returns (uint256) {
        uint256 slotConst = 256;
        uint256 slotLocation;
        uint256 unithash;

        slotLocation = uint256(slotConst ** slot);
        unithash = datatostore * slotLocation;

        return unithash;
    }

    function hashOfSlot64(uint8 slot, uint64 datatostore) internal pure returns (uint64) {
        uint64 slotConst = 64;
        uint64 slotLocation;
        uint64 unithash;

        slotLocation = uint64(slotConst ** slot);
        unithash = datatostore * slotLocation;

        return unithash;
    }

    function hashOfSlot32(uint8 slot, uint32 datatostore) internal pure returns (uint32) {
        uint32 slotConst = 32;
        uint32 slotLocation;
        uint32 unithash;

        slotLocation = uint32(slotConst ** slot);
        unithash = datatostore * slotLocation;

        return unithash;
    }

    /**
     * @notice create an initial 64bits number from a decoded 8bits number.
     */
    function initSourcesCollectHash(uint8 code) internal pure returns (uint64) {
        uint64 initunithash = hashOfSlot64(0, code & 0x01);
        initunithash += hashOfSlot64(1, ((code >> 1) & 0x01));
        initunithash += hashOfSlot64(2, ((code >> 2) & 0x01));
        initunithash += hashOfSlot64(3, ((code >> 3) & 0x01));
        initunithash += hashOfSlot64(4, ((code >> 4) & 0x01));
        initunithash += hashOfSlot64(5, ((code >> 5) & 0x01));
        initunithash += hashOfSlot64(6, ((code >> 6) & 0x01));
        initunithash += hashOfSlot64(7, ((code >> 7) & 0x01));

        return initunithash;
    }

    /**
     * @notice checking which unit is engaged from a decoded 8bits number.
     */
    function focusOnUnitEngagement(uint8 unitEngaged, uint8 slot) internal pure returns (bool feedback) {
        if (slot == 0) {
            uint8 unit = unitEngaged & 0x01;
            return feedback = unit > 0;
        } else {
            uint8 unit = (unitEngaged >> slot) & 0x01;
            return feedback = unit > 0;
        }
    }
}

/*
humint; //indice 0
sigint; //indice 1
geoint; //indice 2
cybint; //indice 3
osint; //indice 4
masint; //indice 5
finint; //indice 6
imint; //indice 7
*/

// function locationHashing(LatLong memory gps) internal pure returns (uint64) {
//     uint64 locationhash = hashOfSlot64(0, gps.latitude);
//     locationhash += hashOfSlot64(1, gps.longitude);

//     return locationhash;
// }

// function unitCollectHashing(SourcesUnit memory unit) internal pure returns (uint64) {
//     uint64 unithash = hashOfSlot64(0, unit.humint);
//     unithash += hashOfSlot64(1, unit.sigint);
//     unithash += hashOfSlot64(3, unit.geoint);
//     unithash += hashOfSlot64(5, unit.cybint);
//     unithash += hashOfSlot64(2, unit.osint);
//     unithash += hashOfSlot64(4, unit.masint);
//     unithash += hashOfSlot64(6, unit.finint);
//     unithash += hashOfSlot64(7, unit.imint);
//     return unithash;
// }

// function decodeUnitEngaging(uint8 code) internal pure returns (SourcesUnit memory units) {
//     // Right-shift the code and mask to extract each trait
//     units.humint = code & 0x01;
//     units.sigint = (code >> 1) & 0x01;
//     units.geoint = (code >> 2) & 0x01;
//     units.cybint = (code >> 3) & 0x01;
//     units.osint = (code >> 4) & 0x01;
//     units.masint = (code >> 5) & 0x01;
//     units.finint = (code >> 6) & 0x01;
//     units.imint = (code >> 7) & 0x01;
//     return units;
// }
