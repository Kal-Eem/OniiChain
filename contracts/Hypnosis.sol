// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IHypnosis.sol";
import "./interfaces/IHypnosisDescriptor.sol";

/// @title Hypnosis NFTs
/// @notice On-chain generated NFTs
contract Hypnosis is ERC721Enumerable, Ownable, IHypnosis {
    /// @dev Price for one character
    uint256 private _unitPrice = 0.01 ether;

    /// @dev The token ID character detail
    mapping(uint256 => Detail) private _detail;

    /// @dev The address of the token descriptor contract, which handles generating token URIs.
    address private immutable _tokenDescriptor;

    /// @notice Details about the character
    struct Detail {
        uint8 hair;
        uint8 eye;
        uint8 nose;
        uint8 mouth;
        uint8 background;
        uint8 skin;
        uint256 timestamp;
        address creator;
    }

    constructor(address _tokenDescriptor_) ERC721("Hypnosis", "HYPNO") {
        _tokenDescriptor = _tokenDescriptor_;
    }

    // save bytecode by removing implementation of unused method
    function _baseURI() internal view virtual override returns (string memory) {}

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return IHypnosisDescriptor(_tokenDescriptor).tokenURI(this, tokenId);
    }

    /// @notice Create randomly a character
    /// @param qty The quantity to buy
    function create(uint256 qty) public payable {
        require(msg.value >= _unitPrice * qty, "Ether sent is not correct");

        // TODO generate detail
        // TODO reentrancy ?

        for (uint256 i; i < qty; i++) {
            _safeMint(msg.sender, totalSupply() + i);
        }
    }

    /// @notice Send funds from sales to the owner
    function withdrawAll() public payable onlyOwner {
        require(payable(0x838D23a8A17adaa6866969b86D35Ac0941C67510).send(address(this).balance));
    }

    /// @inheritdoc IHypnosis
    function details(uint256 tokenId)
        external
        view
        override
        returns (
            uint8 hair,
            uint8 eye,
            uint8 nose,
            uint8 mouth,
            uint8 background,
            uint8 skin,
            uint256 timestamp,
            address creator
        )
    {
        return (0, 0, 0, 0, 0, 0, 0, address(0)); // TODO
    }
}