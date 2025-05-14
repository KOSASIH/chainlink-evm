// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UltimateDecentralizedInsurance is Ownable {
    using SafeMath for uint256;

    struct Policy {
        address policyholder;
        uint256 premium;
        uint256 coverageAmount;
        uint256 duration; // in seconds
        uint256 startTime;
        bool isActive;
        bool isClaimed;
    }

    struct Claim {
        address policyholder;
        uint256 amount;
        bool isApproved;
    }

    mapping(address => Policy) public policies;
    mapping(uint256 => Claim) public claims;
    uint256 public claimCount;
    IERC20 public stablecoin;

    event PolicyCreated(address indexed policyholder, uint256 premium, uint256 coverageAmount, uint256 duration);
    event PolicyClaimed(address indexed policyholder, uint256 amount);
    event ClaimApproved(uint256 claimId, address indexed policyholder, uint256 amount);
    event ClaimDenied(uint256 claimId, address indexed policyholder);

    constructor(address _stablecoin) {
        stablecoin = IERC20(_stablecoin);
    }

    function createPolicy(uint256 premium, uint256 coverageAmount, uint256 duration) external {
        require(premium > 0, "Premium must be greater than 0");
        require(coverageAmount > 0, "Coverage amount must be greater than 0");
        require(duration > 0, "Duration must be greater than 0");

        stablecoin.transferFrom(msg.sender, address(this), premium);

        policies[msg.sender] = Policy({
            policyholder: msg.sender,
            premium: premium,
            coverageAmount: coverageAmount,
            duration: duration,
            startTime: block.timestamp,
            isActive: true,
            isClaimed: false
        });

        emit PolicyCreated(msg.sender, premium, coverageAmount, duration);
    }

    function claimPolicy() external {
        Policy storage policy = policies[msg.sender];
        require(policy.isActive, "No active policy");
        require(!policy.isClaimed, "Policy already claimed");
        require(block.timestamp <= policy.startTime.add(policy.duration), "Policy duration expired");

        claims[claimCount] = Claim({
            policyholder: msg.sender,
            amount: policy.coverageAmount,
            isApproved: false
        });

        policy.isClaimed = true;
        claimCount++;

        emit PolicyClaimed(msg.sender, policy.coverageAmount);
    }

    function approveClaim(uint256 claimId) external onlyOwner {
        Claim storage claim = claims[claimId];
        require(!claim.isApproved, "Claim already approved");

        claim.isApproved = true;
        stablecoin.transfer(claim.policyholder, claim.amount);

        emit ClaimApproved(claimId, claim.policyholder, claim.amount);
    }

    function denyClaim(uint256 claimId) external onlyOwner {
        Claim storage claim = claims[claimId];
        require(!claim.isApproved, "Claim already approved");

        claim.isApproved = false;

        emit ClaimDenied(claimId, claim.policyholder);
    }

    function getPolicyInfo(address policyholder) external view returns (uint256 premium, uint256 coverageAmount, uint256 duration, bool isActive, bool isClaimed) {
        Policy storage policy = policies[policyholder];
        return (policy.premium, policy.coverageAmount, policy.duration, policy.isActive, policy.isClaimed);
    }

    function getClaimInfo(uint256 claimId) external view returns (address policyholder, uint256 amount, bool isApproved) {
        Claim storage claim = claims[claimId];
        return (claim.policyholder, claim.amount, claim.isApproved);
    }
}
