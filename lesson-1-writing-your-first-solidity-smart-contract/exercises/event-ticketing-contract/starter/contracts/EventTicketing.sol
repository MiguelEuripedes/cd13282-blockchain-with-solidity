// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EventTicketing {
    // Define a struct named Ticket to store ticket information, 
    // including the attendee's name, the ticket ID, and whether the ticket has been used.
    struct Ticket{
        string attendeeName;
        uint ticketId;
        bool isUsed;
    }

    // Declare a variable for the event name and maximum tickets for the event.
    string public eventName;
    uint public maxTickets;
    // Declare a counter variable for the total number of tickets sold.
    uint public totalTicketsSold;

    // Declare a mapping to track tickets sold by ticket ID.
    mapping(uint => Ticket) public ticketsSold;

    // TODO: Declare an event for when a ticket is purchased.
    event TicketPurchased(uint ticketId, string attendeeName);
    
    // Function to set event details like name and maximum tickets available.
    // Ensure that the event name is not empty and the maximum number of tickets is greater than 0.
    function setEventDetails(string memory _eventName, uint _maxTickets) public {
        require(bytes(_eventName).length > 0, "Event name cannot be empty");
        require(_maxTickets > 0, "There should be at least one ticket");
        eventName = _eventName;
        maxTickets = _maxTickets;
    }

    // Function to purchase tickets.
    // Ensure the sale doesn't exceed the maximum number of tickets.
    // Increment the ticket counter and assign a new ticket to the purchaser.
    function purchaseTicket(string memory attendeeName) public {
        require(totalTicketsSold < maxTickets, "All tickets have been sold");
        uint ticketId = totalTicketsSold + 1;
        // Assigns new ticket to the purchaser
        ticketsSold[ticketId] = Ticket(attendeeName, ticketId, false);
        totalTicketsSold += 1;

        emit TicketPurchased(ticketId, attendeeName);
    }

    // Function to mark a ticket as used when attending the event.
    // Ensure that the ticket exists and has not been used before.
    function useTicket(uint ticketId) public{
        require(ticketId > 0 && ticketId <= totalTicketsSold, "Invalid ticket ID");
        Ticket storage ticket = ticketsSold[ticketId];
        require(!ticket.isUsed, "Ticket alredy used");
        ticket.isUsed = true;
    }
}
