pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/utils/introspection/ERC165.sol';


interface IERC2981Royalties {
    
    function royaltyInfo(uint256 _tokenId, uint256 _value)
        external
        view
        returns (address _receiver, uint256 _royaltyAmount);
}

/// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
abstract contract RoyalSongs is ERC165, IERC2981Royalties {
    struct RoyaltyInfo {
        address recipient;
        uint24 amount;
    }

    /// @inheritdoc ERC165
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return
            interfaceId == type(IERC2981Royalties).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}

contract MusicContract is ERC1155, Ownable, ERC2981Base {
    
    uint256 public constant SONGS = 0;
    uint256 public constant VIDEO = 1;
    RoyaltyInfo private _royalties;
    
    constructor() ERC1155("https://wzh58eid3jnd.usemoralis.com/{id}.json") {
        _setRoyalties({}, {ROYALTY PERCENTAGE IN BASIS POINTS});
        _mint(msg.sender, SONGS, 1, "");
        _mint(msg.sender, VIDEO, 2, "");
    }
    
    // This is just for OpenSea to find your metadata containing the royalties. 
    // This metadata is about the contract and not the individual NFTs
    function contractURI() public view returns (string memory) {
        return "https://metadata-url.com/my-metadata";
    }
    
    function mint( address to, uint256 id, uint256 amount) public onlyOwner {
        _mint(to, id, amount, "");
    }
    function burn( address from, uint256 id, uint256 amount) public {
        require(msg.sender == from);
        _burn(from, id, amount);
    }
    
    
    // Value is in basis points so 10000 = 100% , 100 = 1% etc
    function _setRoyalties(address recipient, uint256 value) internal {
        require(value <= 10000, 'ERC2981Royalties: Too high');
        _royalties = RoyaltyInfo(recipient, uint24(value));
    }


    function royaltyInfo(uint256, uint256 value)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        RoyaltyInfo memory royalties = _royalties;
        receiver = royalties.recipient;
        royaltyAmount = (value * royalties.amount) / 10000;
    }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC2981Base) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    
}
