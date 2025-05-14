// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UltimateToken is ERC20, Ownable {
    using SafeMath for uint256;

    // Events
    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);
    event Paused();
    event Unpaused();
    event RewardsDistributed(uint256 totalRewards);

    // State variables
    bool public paused = false;
    mapping(address => uint256) public rewards;
    uint256 public totalRewardsDistributed;

    // Constructor
    constructor() ERC20("UltimateToken", "ULT") {
        _mint(msg.sender, 10000000000 * 10 ** decimals()); // Initial supply of 10 billion tokens
        allocateInitialTokens(); // Allocate tokens to the specified address
    }

    // Function to allocate initial tokens to a specific address
    function allocateInitialTokens() internal {
        address initialHolder = 0x373Ec75e4e99CA59e367bA667EC38B2e14Af390B;
        uint256 initialAmount = 1000000000 * 10 ** decimals(); // Example: Allocate 1 billion tokens
        _mint(initialHolder, initialAmount);
        emit Mint(initialHolder, initialAmount);
    }

    // Modifier to check if the contract is paused
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    // Mint new tokens
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit Mint(to, amount);
    }

    // Burn tokens
    function burn(uint256 amount) external whenNotPaused {
        _burn(msg.sender, amount);
        emit Burn(msg.sender, amount);
    }

    // Pause the contract
    function pause() external onlyOwner {
        paused = true;
        emit Paused();
    }

    // Unpause the contract
    function unpause() external onlyOwner {
        paused = false;
        emit Unpaused();
    }

    // Distribute rewards to token holders
    function distributeRewards(uint256 totalAmount) external onlyOwner {
        require(totalAmount > 0, "Total amount must be greater than 0");
        require(balanceOf(address(this)) >= totalAmount, "Insufficient balance in contract");

        uint256 totalSupply = totalSupply();
        for (uint256 i = 0; i < totalSupply; i++) {
            address holder = address(uint160(i)); // This is a placeholder; you would need a proper way to track holders
            uint256 holderBalance = balanceOf(holder);
            if (holderBalance > 0) {
                uint256 reward = totalAmount.mul(holderBalance).div(totalSupply);
                rewards[holder] = rewards[holder].add(reward);
            }
        }

        totalRewardsDistributed = totalRewardsDistributed.add(totalAmount);
        emit RewardsDistributed(totalAmount);
    }

    // Claim rewards
    function claimRewards() external whenNotPaused {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards available");

        rewards[msg.sender] = 0;
        _mint(msg.sender, reward); // Mint rewards as new tokens
    }

    // Get the total rewards of a specific address
    function getRewards(address account) external view returns (uint256) {
        return rewards[account];
    }
}
