// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IRelay {
    function broadcastRequest(
        address _handler,
        address _user,
        uint256 _fee,
        uint256 _deadline,
        bytes memory _data
    ) external returns (uint256 requestId);

    function fetchFromGF(address _handler, uint256 _requestId) external;
}