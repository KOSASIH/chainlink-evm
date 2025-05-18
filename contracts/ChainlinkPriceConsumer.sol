// contracts/ChainlinkPriceConsumer.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChainlinkPriceConsumer is Ownable {
    AggregatorV3Interface internal priceFeed;
    string public constant SYMBOL = "Pi";
    uint256 public constant PRICE_TARGET = 314159 * 1e8; // $314,159 in 8 decimals
    uint256 public constant MAX_DEVIATION = 5; // 5%

    event PriceUpdated(uint256 price);
    event ValidationFailed(uint256 price);

    constructor(address _priceFeedAddress) Ownable(msg.sender) {
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    /**
     * @dev Fetch latest Pi Coin price
     * @return uint256 Price in USD (8 decimals)
     */
    function getLatestPrice() external returns (uint256) {
        (
            /* uint80 roundID */,
            int256 price,
            /* uint startedAt */,
            uint timeStamp,
            /* uint80 answeredInRound */
        ) = priceFeed.latestRoundData();

        require(timeStamp > 0, "Price feed unavailable");
        require(price > 0, "Invalid price");

        uint256 uPrice = uint256(price);
        emit PriceUpdated(uPrice);

        // Validate against target
        uint256 deviation = uPrice > PRICE_TARGET
            ? (uPrice - PRICE_TARGET) * 100 / PRICE_TARGET
            : (PRICE_TARGET - uPrice) * 100 / PRICE_TARGET;
        if (deviation > MAX_DEVIATION) {
            emit ValidationFailed(uPrice);
        }

        return uPrice;
    }

    /**
     * @dev Update price feed address
     */
    function updatePriceFeed(address _newPriceFeedAddress) external onlyOwner {
        priceFeed = AggregatorV3Interface(_newPriceFeedAddress);
    }
}
