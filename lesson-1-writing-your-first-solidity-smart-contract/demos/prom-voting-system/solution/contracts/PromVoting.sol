// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/math/Math.sol";

contract PromVoting {
    // Using math library for uint 256 type for any necessary mathematical operations beyond basic arithmetic.
    using Math for uing256;

    // Define a struct to hold candidate details
    struct Candidate {
        uint id; // Unique identifier for the candidate
        string name;
        uint voteCount;
        address candidateAddress;
    }

    // New struct to capture when each vote is cast
    struct Vote {
        uint candidateId;
        uint timestamp; // Timestamp when the vote was cast
    }

    // Mapping from candidate ID to Candidate struct for storing candidates
    mapping(uint => Candidate) public candidates;
    // Mapping from voter's address to Vote Struct for storing votes cast by each voter
    mapping(address => Vote) public votes;
    // Mapping to track which address are registered to vote
    mapping(address => bool) public registeredVoters;

    // Counter for the total number of candidates
    uint public candidatesCount;
    uint public totalVotes;

    // State variables for time management
    uint public startTime;
    uint public endTime;

    // Owner of the contract, typically the deployer
    address public owner;

    // Threshold of votes needed for a candidate to automatically win
    uint public winningThreshold;

    // Event to be emitted when a vote is cast
    event VoteCast(uint candidateId, uint timestamp);
    // Event declared for when a winner is determined based on the threshold
    event WinnerDeclared(uint candidateId);

    // Modifier to restrict certain actions to the contract's owner
    modifier onlyOwner(){
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    // Modifier to ensure actions are taken only during the allowed voting period
    modifier onlyDuringVotingPeriod(){
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is not currently open.");
        _;
    }

    // Modifier to allow only registered voters to proceed with voting
    modifier onlyRegisteredVoters(){
        require(registeredVoters[msg.sender], "You must be a registered voter.");
        _;
    }

    // Modifier to prevent a candidate from voting for themselves
    modifier cannotVoteForSelf(uint _candidateId){
        require(candidates[_candidateId].candidateAddress != msg.sender, "You cannot vote for yourself.");
        _;
    }

    // Constructor to set the voting duration starting from deployment
    constructor(uint _votingDuration, uint _winningThreshold){
        startTime = block.timestamp;
        endTime = startTime + _votingDuration;
        owner = msg.sender; // Assign contract deployer as the owner
        winningThreshold = _winningThreshold;
    }

    function registerVoter(address _voter) public onlyOwner{
        registeredVoters[_voter] = true;
    }

    // Function to add a new candidate to the election
    function addCandidate(string memory _name, address _candidateAddress) public onlyOwner{
        candidatesCount += 1;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, _candidateAddress);
    }

    // Function to vote for a candidate
    function vote(uint _candidateId) public onlyDuringVotingPeriod onlyRegisteredVoters cannotVoteForSelf{
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is not currently open.");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        // Increment the candidate's vote count
        candidates[_candidateId].voteCount += 1;

        // Record Vote, using the sender address
        votes[msg.sender] = Vote(_candidateId, block.timestamp);

        // Keeping a running total of all votes casted in the election
        totalVotes += 1;

        // Emit a vote event
        emit VoteCast(_candidateId, block.timestamp);
    }

    // Function to get the vote count for a specific candidate
    function getCandidateVoteCount(uint _candidateId) public view returns (uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        return candidates[_candidateId].voteCount;
    }

    function calculateAverageVotes() public view returns (uint){
        if (candidatesCount == 0) return 0;
        return totalVotes / candidatesCount;
    }

    function checkAndRegisterWinner() public {
        uint256 highestVotes = 0;
        uint256 winnerId = 0;
        for (uint i = 1; i <= candidatesCount; i++) {
            uint256 candidateVotes = candidates[i].voteCount;
            if (candidateVotes >= winningThreshold) {
                highestVotes = Math.max(highestVotes, candidateVotes);
                winnerId = i;
            }
        }
        if (winnerId > 0) {
            emit WinnerDeclared(winnerId);
        }
    }
}
