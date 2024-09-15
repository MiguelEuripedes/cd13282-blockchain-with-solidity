// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

contract EventTicketing is Ownable {
    // Define a struct to store ticket information
    struct Ticket {
        string attendeeName;
        uint ticketId;
        bool isUsed;
        uint timestamp; // To track when ticket was purchased
    }

    string public eventName;
    uint public totalTicketsSold;
    uint public maxTickets;

    uint public startTime;
    uint public endTime;
    
    mapping(uint => Ticket) public ticketsSold;
    
    event TicketPurchased(uint ticketId, string attendeeName, uint timestamp);

    // Modifier to ensure actions are taken within the ticket sales period.
    modifier salesOpen(){
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Ticket sales are not open.");
        _;
    }

    // Initialize the contract with start and end times for ticket sales
    constructor(uint _startTime, uint _endTime, address initialOwner) Ownable (initialOwner){
        require(_endTime > _startTime, "End time must be after start time");
        startTime = _startTime;
        endTime = _endTime;
    }

    // Set event details like name and max tickets
    function setEventDetails(string memory _eventName, uint _maxTickets) public onlyOwner{
        require(bytes(_eventName).length > 0, "Event name cannot be empty");
        require(_maxTickets > 0, "There should be at least one ticket");
        eventName = _eventName;
        maxTickets = _maxTickets;
    }

    // Purchase a ticket
    function purchaseTicket(string memory attendeeName) public salesOpen{
        require(totalTicketsSold < maxTickets, "All tickets have been sold");
        uint ticketId = totalTicketsSold + 1;
        
        ticketsSold[ticketId] = Ticket(attendeeName, ticketId, false, block.timestamp);
        totalTicketsSold += 1;
        
        emit TicketPurchased(ticketId, attendeeName, block.timestamp);
    }

    // Use a ticket
    function useTicket(uint ticketId) public {
        require(ticketId > 0 && ticketId <= totalTicketsSold, "Invalid ticket ID");
        Ticket storage ticket = ticketsSold[ticketId];
        require(!ticket.isUsed, "Ticket already used");
        ticket.isUsed = true;
    }
}
