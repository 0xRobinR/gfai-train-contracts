// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../interfaces/IHandler.sol";
import "./RelayRequest.sol";

contract Relay is RelayRequest {
    function initialize() external initializer {
        __Ownable_init();
    }

    function broadcastRequest(
        address _handler,
        address _user,
        uint256 _fee,
        uint256 _deadline,
        bytes memory _data
    ) external onlyRelayer returns (uint256 requestId) {
        requestId = IHandler(_handler).createRequest(_user, _fee, _deadline, _data);
        emit RelayRequestBroadcasted(_handler, _user, _fee, _deadline, _data, requestId);
    }

    function fetchFromGF(address _handler, uint256 _requestId) external onlyRelayer {
        // fetching implementaion for getting file data of the processed model
    }
}