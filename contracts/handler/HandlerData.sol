// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract HandlerData is OwnableUpgradeable {

    event HandleRequestCreated(address indexed user, uint256 indexed nonce, uint256 fee, uint256 deadline, bytes data, uint indexed requestId);
    event HandleRequestProcessed(uint indexed requestId);
    event HandleRequestCancelled(uint indexed requestId);

    enum Handler { Invalid, GFTrainer, Handler, Relayer }
    enum RequestStatus { Invalid, Pending, Processed, Cancelled }
    
    struct HandleRequest {
        address user;
        uint256 fee;
        uint256 nonce;
        uint256 deadline;
        bytes data;
        bool isProcessed;
        RequestStatus status;
    }

    uint public requestCount;

    mapping (address => Handler) public handlerCall;
    mapping (uint => HandleRequest) public handleRequests;

    modifier onlyHandler() {
        require(handlerCall[msg.sender] == Handler.Handler, "HandlerData: not handler");
        _;
    }

    modifier onlyRelayer() {
        require(handlerCall[msg.sender] == Handler.Relayer, "HandlerData: not relayer");
        _;
    }

    modifier onlyGFTrainer() {
        require(handlerCall[msg.sender] == Handler.GFTrainer, "HandlerData: not gf trainer");
        _;
    }

    function setGFTrainer(address _gfTrainer) external onlyOwner {
        handlerCall[_gfTrainer] = Handler.GFTrainer;
    }

    function setHandler(address[] memory _handlers, Handler[] memory _types) external onlyOwner {
        require(_handlers.length == _types.length, "HandlerData: invalid length");
        for (uint256 i = 0; i < _handlers.length; i++) {
            handlerCall[_handlers[i]] = _types[i];
        }
    }

    function setRelayer(address _relayer) external onlyOwner {
        handlerCall[_relayer] = Handler.Relayer;
    }
    
}