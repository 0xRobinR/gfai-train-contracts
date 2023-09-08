// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./interfaces/IRelay.sol";

contract GFTrain is OwnableUpgradeable {

    event Training(address indexed user, uint256 indexed nonce, uint256 fee, uint256 deadline, bytes data, uint indexed requestId);
    event TrainingProcessed(uint indexed requestId);
    event TrainingCancelled(uint indexed requestId);
    event GFTrainerRegistered(address indexed gfTrainer);

    enum RequestStatus { Invalid, Pending, Processed, Cancelled }
    enum Roles { Invalid, GFTrainer }

    struct TrainRequest {
        address user;
        uint256 fee;
        uint256 nonce;
        bytes data;
        bool isProcessed;
        RequestStatus status;
    }

    struct TrainedModel {
        bytes modelMetaInfo;
        string modelName;
        string modelType;
        uint timeTook;
        address updatedBy;
    }

    uint public requestCount;

    mapping (uint => TrainRequest) public trainRequests;
    mapping (uint => TrainedModel) public trainedModels;
    mapping (address => Roles) public roles;

    address public Relay;

    modifier onlyGFTrainer() {
        require(msg.sender == owner(), "GFTrain: not gf trainer");
        _;
    }

    function initialize() external initializer {
        __Ownable_init();
    }

    function createRequest( 
        address _user,
        uint256 _fee,
        uint256 _nonce,
        bytes memory _data
    ) external returns (uint256 requestId) {
        requestId = ++requestCount;
        trainRequests[requestId] = TrainRequest({
            user: _user,
            fee: _fee,
            nonce: _nonce,
            data: _data,
            isProcessed: false,
            status: RequestStatus.Pending
        });

        IRelay(Relay).broadcastRequest(address(this), _user, _fee, block.timestamp, _data);
        emit Training(_user, _nonce, _fee, block.timestamp, _data, requestId);
    }

    function updateTrainedModel(
        uint256 _requestId,
        bytes memory _modelMetaInfo,
        string memory _modelName,
        string memory _modelType,
        uint _timeTook
    ) external onlyGFTrainer {
        TrainRequest storage request = trainRequests[_requestId];
        require(request.status == RequestStatus.Pending, "GFTrain: invalid status");
        request.isProcessed = true;
        request.status = RequestStatus.Processed;

        trainedModels[_requestId] = TrainedModel({
            modelMetaInfo: _modelMetaInfo,
            modelName: _modelName,
            modelType: _modelType,
            timeTook: _timeTook,
            updatedBy: msg.sender
        });

        emit TrainingProcessed(_requestId);
    }

    function getModels(uint256 _requestId) external view returns (TrainedModel memory) {
        return trainedModels[_requestId];
    }

    function cancelRequest(uint256 _requestId) external onlyGFTrainer {
        TrainRequest storage request = trainRequests[_requestId];
        require(request.status == RequestStatus.Pending, "GFTrain: invalid status");
        request.status = RequestStatus.Cancelled;
        emit TrainingCancelled(_requestId);
    }

    function setRelay(address _relay) external onlyOwner {
        Relay = _relay;
    }

    function registerGFTrainer(address _gfTrainer) external onlyOwner {
        roles[_gfTrainer] = Roles.GFTrainer;

        emit GFTrainerRegistered(_gfTrainer);
    }
}