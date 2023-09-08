// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IHandler {
    function createRequest( 
        address _user,
        uint256 _fee,
        uint256 _deadline,
        bytes memory _data
    ) external returns (uint256 requestId);
}