// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UltimateSocialMedia is Ownable {
    using SafeMath for uint256;

    struct User {
        string username;
        bool isRegistered;
        uint256 reputation;
    }

    struct Post {
        uint256 id;
        address creator;
        string content;
        uint256 upvotes;
        uint256 downvotes;
        uint256 tips;
        bool exists;
    }

    mapping(address => User) public users;
    mapping(uint256 => Post) public posts;
    mapping(address => mapping(uint256 => bool)) public userVotes; // user => postId => voted
    uint256 public postCount;
    IERC20 public rewardToken;

    event UserRegistered(address indexed user, string username);
    event PostCreated(uint256 indexed postId, address indexed creator, string content);
    event PostUpvoted(uint256 indexed postId, address indexed voter);
    event PostDownvoted(uint256 indexed postId, address indexed voter);
    event PostTipped(uint256 indexed postId, address indexed tipper, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    constructor(address _rewardToken) {
        rewardToken = IERC20(_rewardToken);
    }

    function registerUser (string memory username) external {
        require(!users[msg.sender].isRegistered, "User  already registered");
        users[msg.sender] = User({
            username: username,
            isRegistered: true,
            reputation: 0
        });
        emit UserRegistered(msg.sender, username);
    }

    function createPost(string memory content) external {
        require(users[msg.sender].isRegistered, "User  not registered");
        postCount++;
        posts[postCount] = Post({
            id: postCount,
            creator: msg.sender,
            content: content,
            upvotes: 0,
            downvotes: 0,
            tips: 0,
            exists: true
        });
        emit PostCreated(postCount, msg.sender, content);
    }

    function upvotePost(uint256 postId) external {
        require(users[msg.sender].isRegistered, "User  not registered");
        require(posts[postId].exists, "Post does not exist");
        require(!userVotes[msg.sender][postId], "User  has already voted");

        posts[postId].upvotes++;
        userVotes[msg.sender][postId] = true;
        users[posts[postId].creator].reputation++;

        emit PostUpvoted(postId, msg.sender);
    }

    function downvotePost(uint256 postId) external {
        require(users[msg.sender].isRegistered, "User  not registered");
        require(posts[postId].exists, "Post does not exist");
        require(!userVotes[msg.sender][postId], "User  has already voted");

        posts[postId].downvotes++;
        userVotes[msg.sender][postId] = true;
        users[posts[postId].creator].reputation--;

        emit PostDownvoted(postId, msg.sender);
    }

    function tipPost(uint256 postId, uint256 amount) external {
        require(users[msg.sender].isRegistered, "User  not registered");
        require(posts[postId].exists, "Post does not exist");
        require(amount > 0, "Tip amount must be greater than 0");

        rewardToken.transferFrom(msg.sender, posts[postId].creator, amount);
        posts[postId].tips += amount;

        emit PostTipped(postId, msg.sender, amount);
    }

    function claimRewards() external {
        uint256 reward = users[msg.sender].reputation.mul(10**18); // Example reward calculation
        require(reward > 0, "No rewards to claim");

        users[msg.sender].reputation = 0; // Reset reputation after claiming rewards
        rewardToken.transfer(msg.sender, reward);

        emit RewardsClaimed(msg.sender, reward);
    }

    function getPostInfo(uint256 postId) external view returns (address creator, string memory content, uint256 upvotes, uint256 downvotes, uint256 tips) {
        require(posts[postId].exists, "Post does not exist");
        Post storage post = posts[postId];
        return (post.creator, post.content, post.upvotes, post.downvotes, post.tips);
    }

    function get User Info(address user) external view returns (string memory username, uint256 reputation) {
        require(users[user].isRegistered, "User  not registered");
        User storage userInfo = users[user];
        return (userInfo.username, userInfo.reputation);
    }
}
