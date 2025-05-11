// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StableCoin {
    string public name = "Pi Coin";
    string public symbol = "PI";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        totalSupply = 100000000000 * 10 ** uint256(decimals); // Total supply set to 100 billion
        balanceOf[msg.sender] = totalSupply; // Assign total supply to the contract creator
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
}

contract LiquidityPool {
    mapping(address => uint256) public liquidity;
    event LiquidityAdded(address indexed provider, uint256 amount);
    event LiquidityRemoved(address indexed provider, uint256 amount);

    function addLiquidity(uint256 amount) public {
        liquidity[msg.sender] += amount;
        emit LiquidityAdded(msg.sender, amount);
    }

    function removeLiquidity(uint256 amount) public {
        require(liquidity[msg.sender] >= amount, "Insufficient liquidity");
        liquidity[msg.sender] -= amount;
        emit LiquidityRemoved(msg.sender, amount);
    }
}

contract PriceOracle {
    uint256 public currentPrice = 314159; // Set initial price to $314,159

    function updatePrice(uint256 newPrice) public {
        currentPrice = newPrice;
    }

    function getPrice() public view returns (uint256) {
        return currentPrice;
    }
}
