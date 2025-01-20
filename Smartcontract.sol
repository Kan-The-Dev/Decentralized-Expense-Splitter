// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedExpenseSplitter {
    struct Group {
        address[] members;
        mapping(address => bool) hasDeposited;
        uint256 totalBalance;
        bool exists;
    }
    
    struct PaymentRequest {
        address requester;
        uint256 amount;
        mapping(address => bool) approvals;
        uint256 approvalCount;
        mapping(address => bool) additionalContributions;
        uint256 additionalFunds;
        bool executed;
    }
    
    mapping(bytes32 => Group) public groups;
    mapping(bytes32 => PaymentRequest) public paymentRequests;
    mapping(address => uint256) public userBalances;

    event GroupCreated(bytes32 indexed groupId, address[] members);
    event Deposited(bytes32 indexed groupId, address indexed member, uint256 amount);
    event PaymentRequested(bytes32 indexed groupId, address indexed requester, uint256 amount);
    event PaymentApproved(bytes32 indexed groupId, address indexed approver);
    event AdditionalFundsAdded(bytes32 indexed groupId, address indexed contributor, uint256 amount);
    event PaymentExecuted(bytes32 indexed groupId, address indexed requester, uint256 amount);
    
    function createGroup(address[] memory _members) public returns (bytes32) {
        require(_members.length > 1, "At least two members required");
        bytes32 groupId = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        groups[groupId].members = _members;
        groups[groupId].exists = true;
        emit GroupCreated(groupId, _members);
        return groupId;
    }
    
    function depositToGroup(bytes32 _groupId) public payable {
        require(groups[_groupId].exists, "Group does not exist");
        require(msg.value > 0, "Deposit must be greater than zero");
        require(!groups[_groupId].hasDeposited[msg.sender], "Already deposited");
        
        groups[_groupId].hasDeposited[msg.sender] = true;
        groups[_groupId].totalBalance += msg.value;
        emit Deposited(_groupId, msg.sender, msg.value);
    }
    
    function requestPayment(bytes32 _groupId, uint256 _amount) public {
        require(groups[_groupId].exists, "Group does not exist");
        require(groups[_groupId].totalBalance + getAdditionalFunds(_groupId) >= _amount, "Insufficient funds");
        
        bytes32 requestId = keccak256(abi.encodePacked(_groupId, msg.sender, block.timestamp));
        paymentRequests[requestId].requester = msg.sender;
        paymentRequests[requestId].amount = _amount;
        emit PaymentRequested(_groupId, msg.sender, _amount);
    }
    
    function approvePayment(bytes32 _groupId, bytes32 _requestId) public {
        require(groups[_groupId].exists, "Group does not exist");
        require(paymentRequests[_requestId].requester != address(0), "Payment request does not exist");
        require(!paymentRequests[_requestId].approvals[msg.sender], "Already approved");
        
        paymentRequests[_requestId].approvals[msg.sender] = true;
        paymentRequests[_requestId].approvalCount++;
        emit PaymentApproved(_groupId, msg.sender);
        
        if (paymentRequests[_requestId].approvalCount == groups[_groupId].members.length) {
            executePayment(_groupId, _requestId);
        }
    }
    
    function addFundsToPaymentRequest(bytes32 _groupId, bytes32 _requestId) public payable {
        require(groups[_groupId].exists, "Group does not exist");
        require(paymentRequests[_requestId].requester != address(0), "Payment request does not exist");
        require(msg.value > 0, "Must send some funds");
        require(!paymentRequests[_requestId].additionalContributions[msg.sender], "Already contributed");
        
        paymentRequests[_requestId].additionalContributions[msg.sender] = true;
        paymentRequests[_requestId].additionalFunds += msg.value;
        emit AdditionalFundsAdded(_groupId, msg.sender, msg.value);
    }
    
    function getAdditionalFunds(bytes32 _groupId) internal view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < groups[_groupId].members.length; i++) {
            if (paymentRequests[_groupId].additionalContributions[groups[_groupId].members[i]]) {
                total += paymentRequests[_groupId].additionalFunds;
            }
        }
        return total;
    }
    
    function executePayment(bytes32 _groupId, bytes32 _requestId) internal {
        require(paymentRequests[_requestId].approvalCount == groups[_groupId].members.length, "Not all members approved");
        require(!paymentRequests[_requestId].executed, "Payment already executed");
        
        uint256 totalFunds = groups[_groupId].totalBalance + getAdditionalFunds(_groupId);
        require(totalFunds >= paymentRequests[_requestId].amount, "Insufficient funds after contributions");
        
        paymentRequests[_requestId].executed = true;
        groups[_groupId].totalBalance -= paymentRequests[_requestId].amount;
        payable(paymentRequests[_requestId].requester).transfer(paymentRequests[_requestId].amount);
        emit PaymentExecuted(_groupId, paymentRequests[_requestId].requester, paymentRequests[_requestId].amount);
    }
    
    receive() external payable {}
}
