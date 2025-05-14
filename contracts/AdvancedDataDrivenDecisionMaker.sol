// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract AdvancedDataDrivenDecisionMaker is ChainlinkClient, Ownable {
    using Chainlink for Chainlink.Request;
    using SafeMath for uint256;

    uint256 public dataValue;
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    mapping(address => uint256) public rewards;
    address[] public dataProviders;
    uint256 public tradingThreshold;
    uint256 public lastTradePrice;

    event DataUpdated(uint256 newValue);
    event TradeExecuted(uint256 price, string action);
    event RewardDistributed(address provider, uint256 reward);

    constructor(address _oracle, string memory _jobId, uint256 _fee, uint256 _tradingThreshold) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30cA5B8d8A1B); // LINK token address
        oracle = _oracle;
        jobId = stringToBytes32(_jobId);
        fee = _fee; // LINK fee
        tradingThreshold = _tradingThreshold;
    }

    function requestData() public {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.add("get", "https://api.example.com/data"); // Replace with your API endpoint
        req.add("path", "data.value"); // Adjust based on the API response structure
        sendChainlinkRequestTo(oracle, req, fee);
    }

    function fulfill(bytes32 _requestId, uint256 _dataValue) public recordChainlinkFulfillment(_requestId) {
        dataValue = _dataValue;
        emit DataUpdated(dataValue);
        executeTrade(dataValue);
    }

    function executeTrade(uint256 currentPrice) internal {
        if (currentPrice > lastTradePrice.add(tradingThreshold)) {
            // Execute buy action
            emit TradeExecuted(currentPrice, "BUY");
            lastTradePrice = currentPrice;
            distributeRewards();
        } else if (currentPrice < lastTradePrice.sub(tradingThreshold)) {
            // Execute sell action
            emit TradeExecuted(currentPrice, "SELL");
            lastTradePrice = currentPrice;
            distributeRewards();
        }
    }

    function distributeRewards() internal {
        for (uint256 i = 0; i < dataProviders.length; i++) {
            rewards[dataProviders[i]] = rewards[dataProviders[i]].add(1 ether); // Reward in LINK or another token
            emit RewardDistributed(dataProviders[i], 1 ether);
        }
    }

    function addDataProvider(address provider) external onlyOwner {
        dataProviders.push(provider);
    }

    function removeDataProvider(address provider) external onlyOwner {
        for (uint256 i = 0; i < dataProviders.length; i++) {
            if (dataProviders[i] == provider) {
                dataProviders[i] = dataProviders[dataProviders.length - 1];
                dataProviders.pop();
                break;
            }
        }
    }

    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
    }
}
