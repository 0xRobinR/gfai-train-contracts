// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./RelayData.sol";

contract RelayRequest is RelayData {

    function createRequest(bytes memory _data) external onlyRelayer returns (uint256 requestId) {
        requestId = ++relayRequestCount;
        relayRequests[requestId] = RelayRequest({
            responseData: "",
            data: _data,
            status: RelayStatus.Pending
        });
    }

    function completeRequest(uint256 _requestId, bytes memory _responseData) external onlyRelayer {
        RelayRequest storage request = relayRequests[_requestId];
        require(request.status == RelayStatus.Pending, "RelayData: invalid status");
        request.responseData = _responseData;
        request.status = RelayStatus.Processed;
    }

    function cancelRequest(uint256 _requestId) external onlyRelayer {
        RelayRequest storage request = relayRequests[_requestId];
        require(request.status == RelayStatus.Pending, "RelayData: invalid status");
        request.status = RelayStatus.Cancelled;
    }
}