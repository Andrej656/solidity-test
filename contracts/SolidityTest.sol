//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SolidityTest is ERC721, Ownable {
    uint256 public constant PRICE = 1 ether / 10;
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MAX_PER_TX = 5;

    uint256 public tokenCounter = 1;

    mapping(uint256 => address) private _owners;

    constructor() ERC721("Token", "TOK") {
        // YOUR CODE HERE
    }

    function claim() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Failed to claim");
    }

    function mint(uint256 amount) external payable {
        // YOUR CODE HERE
        require(amount != 0, "Can't mint 0 tokens");
        require(amount <= MAX_PER_TX, "Max 5 tokens per transaction");
        require(msg.value == PRICE * amount, "Need correct payment value");
        require(tokenCounter <= MAX_SUPPLY, "All tokens have been minted");

        for (uint256 i = 1; i <= amount; i++) {
            _safeMint(msg.sender, tokenCounter);
            _owners[tokenCounter] = msg.sender;
            tokenCounter++;
        }
    }

    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        address owner = _owners[tokenId];
        require(
            owner != address(0),
            "ERC721: owner query for nonexistent token"
        );
        return owner;
    }
}
