//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["Lazy", "Spooky", "Lord", "Epic", "Wild", "Hungry", "Tired", "Fast", "Slow", "Attack", "Dumb", "Idiot"];
  string[] secondWords = ["Pizza", "Burger", "Pasta", "Momos", "Chicken", "Cake", "Fries", "Sandwhich", "Juice", "Apple", "Curry", "Coffee"];
  string[] thirdWords = ["Allmight", "Toji", "Yuji", "Kacchan", "Sage", "Gaara", "Jett", "Levi", "Eren", "Erwin", "Lewis", "Max"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);
    
    constructor() ERC721 ("ShreeNFT", "SHR") {  //passing name and symbol
        console.log('printed');
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

     function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

     function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }



    function makeAnNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first  = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third  = pickRandomThirdWord(newItemId);
        string memory finalWord = string(abi.encodePacked(baseSvg, first, second, third));

        string memory finalSvg  = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

        string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    finalWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

       string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );


        console.log("\n--------------------");
        console.log(finalSvg);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId); //mint nft for msg.sender

        _setTokenURI(newItemId, finalTokenUri); //sets nft data
        console.log("An nft w/ ID %s has been minted to %s", newItemId, msg.sender);

        _tokenIds.increment(); //nft counter

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}