// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UltimateNFTMarketplace is Ownable, ERC721 {
    using SafeMath for uint256;

    struct NFT {
        uint256 id;
        address creator;
        uint256 price;
        bool isListed;
        bool isAuction;
        uint256 auctionEndTime;
        address highestBidder;
        uint256 highestBid;
    }

    mapping(uint256 => NFT) public nfts;
    mapping(address => uint256) public rewards;
    uint256 public nftCount;
    IERC20 public rewardToken;

    event NFTCreated(uint256 indexed id, address indexed creator, uint256 price);
    event NFTListed(uint256 indexed id, uint256 price);
    event NFTSold(uint256 indexed id, address indexed buyer, uint256 price);
    event AuctionStarted(uint256 indexed id, uint256 endTime);
    event NewBid(uint256 indexed id, address indexed bidder, uint256 amount);
    event AuctionEnded(uint256 indexed id, address indexed winner, uint256 amount);

    constructor(address _rewardToken) ERC721("UltimateNFT", "UNFT") {
        rewardToken = IERC20(_rewardToken);
    }

    function createNFT(string memory tokenURI, uint256 price) external {
        nftCount++;
        _mint(msg.sender, nftCount);
        _setTokenURI(nftCount, tokenURI);

        nfts[nftCount] = NFT({
            id: nftCount,
            creator: msg.sender,
            price: price,
            isListed: false,
            isAuction: false,
            auctionEndTime: 0,
            highestBidder: address(0),
            highestBid: 0
        });

        emit NFTCreated(nftCount, msg.sender, price);
    }

    function listNFT(uint256 id, uint256 price) external {
        require(ownerOf(id) == msg.sender, "Not the owner");
        nfts[id].isListed = true;
        nfts[id].price = price;

        emit NFTListed(id, price);
    }

    function buyNFT(uint256 id) external payable {
        require(nfts[id].isListed, "NFT not listed");
        require(msg.value >= nfts[id].price, "Insufficient funds");

        address seller = ownerOf(id);
        _transfer(seller, msg.sender, id);
        payable(seller).transfer(msg.value);

        nfts[id].isListed = false;

        emit NFTSold(id, msg.sender, msg.value);
        rewards[seller] = rewards[seller].add(msg.value.div(100)); // Reward seller with 1% of sale price
    }

    function startAuction(uint256 id, uint256 duration) external {
        require(ownerOf(id) == msg.sender, "Not the owner");
        nfts[id].isAuction = true;
        nfts[id].auctionEndTime = block.timestamp.add(duration);
        nfts[id].highestBid = 0;
        nfts[id].highestBidder = address(0);

        emit AuctionStarted(id, nfts[id].auctionEndTime);
    }

    function bid(uint256 id) external payable {
        require(nfts[id].isAuction, "Not an auction");
        require(block.timestamp < nfts[id].auctionEndTime, "Auction ended");
        require(msg.value > nfts[id].highestBid, "Bid not high enough");

        // Refund the previous highest bidder
        if (nfts[id].highestBidder != address(0)) {
            payable(nfts[id].highestBidder).transfer(nfts[id].highestBid);
        }

        nfts[id].highestBidder = msg.sender;
        nfts[id].highestBid = msg.value;

        emit NewBid(id, msg.sender, msg.value);
    }

    function endAuction(uint256 id) external {
        require(nfts[id].isAuction, "Not an auction");
        require(block.timestamp >= nfts[id].auctionEndTime, "Auction not ended");

        if (nfts[id].highestBidder != address(0)) {
            _transfer(ownerOf(id), nfts[id].highestBidder, id);
            payable(ownerOf(id)).transfer(nfts[id].highestBid);
            rewards[ownerOf(id)] = rewards[ownerOf(id)].add(nfts[id].highestBid.div(100)); // Reward seller with 1% of auction price
        }

        nfts[id].isAuction = false;
        nfts[id].highestBidder = address(0);
        nfts[id].highestBid = 0;

        emit AuctionEnded(id, nfts[id].highestBidder, nfts[id].highestBid);
    }

    function claimRewards() external {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to claim");

        rewards[msg.sender] = 0;
        rewardToken.transfer(msg.sender, reward);
    }

    function getNFTInfo(uint256 id) external view returns (address creator, uint256 price, bool isListed, bool isAuction, uint256 auctionEndTime, address highestBidder, uint256 highestBid) {
        NFT storage nft = nfts[id];
        return (nft.creator, nft.price, nft.isListed, nft.isAuction, nft.auctionEndTime, nft.highestBidder, nft.highestBid);
    }
}
