// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UltimateDeFiPlatform is Ownable {
    using SafeMath for uint256;

    struct Loan {
        uint256 amount;
        uint256 interestRate; // in basis points (e.g., 500 = 5%)
        uint256 duration; // in seconds
        uint256 startTime;
        bool isActive;
    }

    struct User {
        uint256 stakedAmount;
        uint256 totalBorrowed;
        uint256 totalRepaid;
        uint256 totalRewards;
    }

    mapping(address => User) public users;
    mapping(address => Loan) public loans;
    IERC20 public stablecoin;
    uint256 public totalLiquidity;
    uint256 public totalLoans;
    uint256 public rewardRate; // in basis points

    event LoanRequested(address indexed borrower, uint256 amount, uint256 interestRate, uint256 duration);
    event LoanRepaid(address indexed borrower, uint256 amount);
    event LiquidityAdded(address indexed provider, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    constructor(address _stablecoin, uint256 _rewardRate) {
        stablecoin = IERC20(_stablecoin);
        rewardRate = _rewardRate; // Set reward rate (e.g., 500 = 5%)
    }

    function addLiquidity(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        stablecoin.transferFrom(msg.sender, address(this), amount);
        totalLiquidity = totalLiquidity.add(amount);
        users[msg.sender].stakedAmount = users[msg.sender].stakedAmount.add(amount);
        emit LiquidityAdded(msg.sender, amount);
    }

    function requestLoan(uint256 amount, uint256 interestRate, uint256 duration) external {
        require(amount > 0, "Amount must be greater than 0");
        require(totalLiquidity >= amount, "Insufficient liquidity");
        require(interestRate > 0, "Interest rate must be greater than 0");
        require(duration > 0, "Duration must be greater than 0");

        loans[msg.sender] = Loan({
            amount: amount,
            interestRate: interestRate,
            duration: duration,
            startTime: block.timestamp,
            isActive: true
        });

        totalLiquidity = totalLiquidity.sub(amount);
        totalLoans = totalLoans.add(amount);
        stablecoin.transfer(msg.sender, amount);
        emit LoanRequested(msg.sender, amount, interestRate, duration);
    }

    function repayLoan() external {
        Loan storage loan = loans[msg.sender];
        require(loan.isActive, "No active loan");
        require(block.timestamp <= loan.startTime.add(loan.duration), "Loan duration expired");

        uint256 interest = loan.amount.mul(loan.interestRate).div(10000); // Calculate interest
        uint256 totalRepayment = loan.amount.add(interest);
        stablecoin.transferFrom(msg.sender, address(this), totalRepayment);

        users[msg.sender].totalRepaid = users[msg.sender].totalRepaid.add(totalRepayment);
        loan.isActive = false;
        emit LoanRepaid(msg.sender, totalRepayment);
    }

    function claimRewards() external {
        User storage user = users[msg.sender];
        uint256 rewards = user.stakedAmount.mul(rewardRate).div(10000); // Calculate rewards
        require(rewards > 0, "No rewards available");

        user.totalRewards = user.totalRewards.add(rewards);
        stablecoin.transfer(msg.sender, rewards);
        emit RewardsClaimed(msg.sender, rewards);
    }

    function getUser Info(address user) external view returns (uint256 stakedAmount, uint256 totalBorrowed, uint256 totalRepaid, uint256 totalRewards) {
        User storage userInfo = users[user];
        return (userInfo.stakedAmount, userInfo.totalBorrowed, userInfo.totalRepaid, userInfo.totalRewards);
    }

    function getLoanInfo(address borrower) external view returns (uint256 amount, uint256 interestRate, uint256 duration, bool isActive) {
        Loan storage loan = loans[borrower];
        return (loan.amount, loan.interestRate, loan.duration, loan.isActive);
    }

    function setRewardRate(uint256 newRate) external onlyOwner {
        rewardRate = newRate;
    }
}
