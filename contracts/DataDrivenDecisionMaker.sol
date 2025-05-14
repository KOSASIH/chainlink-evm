// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract DataDrivenDecisionMaker is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    uint256 public dataValue;
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    event DataUpdated(uint256 newValue);

    constructor(address _oracle, string memory _jobId, uint256 _fee) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30cA5B8d8A1B); // LINK token address
        oracle = _oracle;
        jobId = stringToBytes32(_jobId);
        fee = _fee; // LINK fee
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
