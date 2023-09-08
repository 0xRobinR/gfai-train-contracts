// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract RelayData is OwnableUpgradeable {

    event RelayRequestBroadcasted(
        address indexed handler,
        address indexed user,
        uint256 fee,
        uint256 deadline,
        bytes data,
        uint256 requestId
    );

    enum RelayStatus { Invalid, Pending, Processed, Cancelled }
    enum Relayer { Invalid, Valid }

    struct RelayRequest {
        bytes responseData;
        bytes data;
        RelayStatus status;
    }

    mapping (address => Relayer) public relayerCall;
    mapping (uint => RelayRequest) public relayRequests;
    uint public relayRequestCount;

    modifier onlyRelayer() {
        require(relayerCall[msg.sender] == Relayer.Valid, "RelayData: not relayer");
        _;
    }

    function setRelayer(address _relayer) external onlyOwner {
        relayerCall[_relayer] = Relayer.Valid;
    }
}