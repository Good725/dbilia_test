// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DbiliaToken is ERC721 {
    using SafeMath for uint256;

    struct Card {
        address user;
        uint256 edition;
        string tokenUri;
    }

    mapping(uint256 => Card) cards; 

    address public dbilia;
    uint256 private _currentTokenId = 0;

    mapping(uint256 => string) public uriMap;
    mapping(uint256 => uint256) public editionPerCard;

    event MintedWithUSD(address indexed user, uint256 tokenId);
    event MintedWithETH(address indexed user, uint256 tokenId);

    constructor(
        string memory _name,
        string memory _symbol,
        address _dbilia
    ) ERC721(_name, _symbol) {
        dbilia = _dbilia;
    }

    modifier onlyDbilia() {
        require(msg.sender == dbilia, "!dbilia");
        _;
    }

    function mintWithUSD(address user, uint256 cardId, uint256 edition, string memory tokenUri) public onlyDbilia {
        require(cards[cardId].user == address(0x0), "CardId is already exist");
        require(user != address(0x0), "can not mint to zero address");
        uint256 newTokenId = _getNextTokenId();
        _mint(dbilia, newTokenId);
        _incrementTokenId();
        uriMap[newTokenId] = tokenUri;
        editionPerCard[cardId] = edition;
        cards[cardId].user = user;
        cards[cardId].edition = edition;
        cards[cardId].tokenUri = tokenUri;
        emit MintedWithUSD(user, newTokenId);
    }

    function mintWithETH(uint256 cardId, uint256 edition, string memory tokenUri) public payable {
        require(cards[cardId].user == address(0x0), "CardId is already exist");
        require(msg.value > 0, "Insufficient eth amount");
        uint256 newTokenId = _getNextTokenId();
        _mint(msg.sender, newTokenId);
        _incrementTokenId();
        uriMap[newTokenId] = tokenUri;
        editionPerCard[cardId] = edition;
        cards[cardId].user = msg.sender;
        cards[cardId].edition = edition;
        cards[cardId].tokenUri = tokenUri;
        emit MintedWithETH(msg.sender, newTokenId);
    }

    function setDbilia(address newDbilia) public onlyDbilia {
        dbilia = newDbilia;
    }

    function _getNextTokenId() private view returns (uint256) {
        return _currentTokenId.add(1);
    }

    function _incrementTokenId() private {
        _currentTokenId++;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return uriMap[tokenId];
    }

}