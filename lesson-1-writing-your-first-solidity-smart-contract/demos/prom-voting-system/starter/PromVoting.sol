// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PromVoting{
    // Define a struct to hold candidate details
    struct Candidate{
        uint id; //Unique identifer for the candidate
        string name;
        uint voteCount;
    }

    // Mapping from candidate ID to Candidate struct for storing candidatesCount
    mapping(uint => Candidate) public candidates; // Links each candidate ID to its respective candidate

    // Counter for the total number of candidates
    uint public candidateCount;

    function addCandidate(string memory _name) public{
        candidateCount += 1;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
    }

    event VoteCast(uint candidateId);

    function vote(uint _candidateId) public{
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");
        candidates[_candidateId].voteCount += 1;

        emit VoteCast(_candidateId);
    }

    function getCandidateVoteCount(uint _candidateId) public view returns (uint){
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");
        return candidates[_candidateId].voteCount;
    }
}
