// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./HandlerData.sol";

contract HandlerProxy is HandlerData {

    function initialize() external initializer {
        __Ownable_init();
    }
    
    function createRequest( 
        address _user,
        uint256 _fee,
        uint256 _deadline,
        bytes memory _data
    ) external onlyGFTrainer returns (uint256 requestId) {
        requestId = ++requestCount;
        handleRequests[requestId] = HandleRequest({
            user: _user,
            fee: _fee,
            nonce: 0,
            deadline: _deadline,
            data: _data,
            isProcessed: false,
            status: RequestStatus.Pending
        });
        emit HandleRequestCreated(msg.sender, 0, _fee, _deadline, _data, requestId);
    }

    function completeRequest(uint256 _requestId) external onlyHandler {
        HandleRequest storage request = handleRequests[_requestId];
        require(request.status == RequestStatus.Pending, "HandlerProxy: invalid status");
        request.isProcessed = true;
        request.status = RequestStatus.Processed;
        emit HandleRequestProcessed(_requestId);
    }

    function cancelRequest(uint256 _requestId) external onlyHandler {
        HandleRequest storage request = handleRequests[_requestId];
        require(request.status == RequestStatus.Pending, "HandlerProxy: invalid status");
        request.status = RequestStatus.Cancelled;
        emit HandleRequestCancelled(_requestId);
    }
}