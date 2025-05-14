// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UltimateDAO is Ownable {
    using SafeMath for uint256;

    struct Proposal {
        string description;
        uint256 voteCount;
        uint256 endTime;
        mapping(address => bool) votes;
        bool executed;
    }

    struct Member {
        uint256 stake;
        uint256 lastClaimed;
    }

    mapping(address => Member) public members;
    Proposal[] public proposals;
    IERC20 public rewardToken1;
    IERC20 public rewardToken2;
    uint256 public totalStaked;
    uint256 public dynamicFee;
    uint256 public constant FEE_BASE = 10000; // 100% in basis points

    event ProposalCreated(uint256 proposalId, string description, uint256 endTime);
    event Voted(uint256 proposalId, address voter, bool support);
    event ProposalExecuted(uint256 proposalId);
    event Staked(address member, uint256 amount);
    event Unstaked(address member, uint256 amount);
    event RewardsClaimed(address member, uint256 amount1, uint256 amount2);

    constructor(address _rewardToken1, address _rewardToken2) {
        rewardToken1 = IERC20(_rewardToken1);
        rewardToken2 = IERC20(_rewardToken2);
        dynamicFee = 500; // Initial fee set to 5%
    }

    function createProposal(string memory description, uint256 duration) external onlyOwner {
        Proposal storage newProposal = proposals.push();
        newProposal.description = description;
        newProposal.voteCount = 0;
        newProposal.endTime = block.timestamp.add(duration);
        emit ProposalCreated(proposals.length - 1, description, newProposal.endTime);
    }

    function voteOnProposal(uint256 proposalId, bool support) external {
        require(proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.votes[msg.sender], "Already voted");
        require(block.timestamp < proposal.endTime, "Voting period has ended");

        proposal.votes[msg.sender] = true;
        if (support) {
            proposal.voteCount++;
        }
        emit Voted(proposalId, msg.sender, support);
    }

    function executeProposal(uint256 proposalId) external {
        require(proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(block.timestamp >= proposal.endTime, "Voting period not ended");

        // Logic to execute the proposal can be added here
        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        members[msg.sender].stake = members[msg.sender].stake.add(amount);
        totalStaked = totalStaked.add(amount);
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(members[msg.sender].stake >= amount, "Insufficient stake");
        members[msg.sender].stake = members[msg.sender].stake.sub(amount);
        totalStaked = totalStaked.sub(amount);
        emit Unstaked(msg.sender, amount);
    }

    function claimRewards() external {
        uint256 reward1 = calculateReward1(msg.sender);
        uint256 reward2 = calculateReward2(msg.sender);
        require(reward1 > 0 || reward2 > 0, "No rewards available");

        if (reward1 > 0) {
            rewardToken1.transfer(msg.sender, reward1);
        }
        if (reward2 > 0) {
            rewardToken2.transfer(msg.sender, reward2);
        }

        members[msg.sender].lastClaimed = block.timestamp;
        emit RewardsClaimed(msg.sender, reward1, reward2);
    }

    function calculateReward1(address member) internal view returns (uint256) {
        return members[member].stake.mul(dynamicFee).div(FEE_BASE);
    }

    function calculateReward2(address member) internal view returns (uint256) {
        return members[member].stake.mul(dynamicFee).div(FEE_BASE).div(2); // Example logic for second reward
    }

    function adjustDynamicFee(uint256 newFee) external onlyOwner {
        require(newFee <= 1000, "Fee cannot exceed 10%"); // Limit the maximum fee to 10%
        dynamicFee = newFee;
    }

    function getMemberStake(address member) external view returns (uint256) {
        return members[member].stake;
    }

    function getProposalDetails(uint256 proposalId) external view returns (string memory description, uint256 voteCount, bool executed, uint256 endTime) {
        require(proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[proposalId];
        return (proposal.description, proposal.voteCount, proposal.executed, proposal.endTime);
    }

    function getDynamicFee() external view returns (uint256) {
        return dynamicFee;
    }
}
