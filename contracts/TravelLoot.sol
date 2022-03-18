pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract TravelLoot is ERC721Enumerable, ReentrancyGuard, Ownable {

    //uint minPrice = 0.1 ether;
    uint public maxTotalSupply = 10000;

    string[] private Vehicles = [
        "Millennium Falcon",
        "Sling Ring",
        "Nimbus 2000 Broomstick",
        "Pegasus" ,
        "Flying Carpet",
        "Swan Boat",
        "2-headed Sea Snake",
        "Sail Fish",
        "Four-horse chariot",
        "Cheetah",
        "Elephant",
        "Giant Ant"
    ];
    
    string[] private Rarity = [
        "Common",
        "Epic",
        "Legendary",
        "Mythic"
    ];
    
    string[] private Speed = [
        "Blink of an eye",
        "Super Fast",
        "Fast",
        "Medium",
        "Slow",
        "Slug"
    ];
    
    string[] private SpecialPowers = [
        "Spit-fire",
       "Shape-shifting",
        "Indestructible",
        "Cannon-shooting",
        "Shielding",
        "Disappearance",
        "Self-Healing",
        "Camouflage"
    ];
    
    string[] private SecretMetalIngredient = [
        "Neodymium",
        "Cerium",
        "Scandium",
        "Europium",
        "Holmium",
        "Erbium",
        "Lutetium"
    ];
    
    string[] private Color = [
        "Gold",
        "Silver",
        "Fire",
        "Water",
        "Leaf",
        "Cloud"
    ];
    
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    
    function getVehicles(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "Vehicles", Vehicles);
    }
    
    function getRarity(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "Rarity", Rarity);
    }
    
    function getSpeed(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "Speed", Speed);
    }
    
    function getSpecialPowers(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "SpecialPowers", SpecialPowers);
    }

    function getSecretMetalIngredient(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "SecretMetalIngredient", SecretMetalIngredient);
    }
    
    function getColor(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "Color", Color);
    }


    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
        uint256 rand = random(
            string(abi.encodePacked(keyPrefix, toString(tokenId)))
        );
        uint256 required_index = rand % sourceArray.length;
        string memory output = sourceArray[required_index];

        return output;
    }


    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[17] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="35%" y="60" class="base">';

        parts[1] = toString(tokenId);

        parts[2] = '</text><text x="30%" y="100" class="base">';

        parts[3] = getVehicles(tokenId);

        parts[4] = '</text><text x="30%" y="120" class="base">';

        parts[5] = getRarity(tokenId);

        parts[6] = '</text><text x="30%" y="140" class="base">';

        parts[7] = getSpeed(tokenId);

        parts[8] = '</text><text x="30%" y="160" class="base">';

        parts[9] = getSpecialPowers(tokenId);

        parts[10] = '</text><text x="30%" y="180" class="base">';

        parts[11] = getSecretMetalIngredient(tokenId);

        parts[12] = '</text><text x="30%" y="200" class="base">';

        parts[13] = getColor(tokenId);

        parts[14] = '</text><text x="30%" y="60" class="base">';

        parts[15] = "#";

        parts[16] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
        output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Player #', toString(tokenId), '", "description": "CricketLoot", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function claim(uint256 tokenId) public nonReentrant payable {
        //require(msg.value >= minPrice, "Mint price should be greater than 20 matic");
        require(tokenId > 0 && tokenId <= maxTotalSupply, "Token ID invalid");
        _safeMint(_msgSender(), tokenId);
    }

    function withdraw() public onlyOwner {
        uint redeemableBalance = address(this).balance;
        require(redeemableBalance > 0, "Insufficient Balance");
        payable(msg.sender).transfer(redeemableBalance);
    }
    
    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    constructor() ERC721("TravelLoot", "TL") Ownable() {}
}

