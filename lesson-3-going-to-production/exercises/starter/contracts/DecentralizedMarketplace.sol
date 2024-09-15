
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DecentralizedMarketplace {
    struct Item {
        uint id;
        address payable seller; // Allows to send ether to the address stored in these variables
        string name;
        uint price;
        bool available;
    }

    struct Review {
        uint itemId;
        address reviewer;
        string comment;
        uint rating; // Rating out of 5
    }

    // Mapping the address for items and reviews
    // we are mapping each item and review and assigning each of them 
    // it's own unique Id
    address public owner;
    mapping(uint => Item) public items;
    mapping(uint => Review[]) public reviews;
    uint public itemCount = 0;

    // Events declaration that can be emitted on actions.
    event ItemListed(uint indexed itemId, address indexed seller, string name, uint price);
    event ItemPurchased(uint indexed itemId, address indexed buyer, uint price);
    event ReviewAdded(uint indexed itemId, address reviewer, uint rating);

    // Constructor for setting the creator as the owner of the contract
    constructor() {
        owner = msg.sender; // This establishes the deployer as the owner of the marketplace
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Function to list a new item on the marketplace
    function listItem(string memory _name, uint _price) public {
        require(_price > 0, "Price must be greater than 0");
        itemCount++;
        items[itemCount] = Item({
            id: itemCount, // We need the Item ID
            seller: payable(msg.sender), // The seller Address
            name: _name,
            price: _price,
            available: true
        });
        emit ItemListed(itemCount, msg.sender, _name, _price);
    }

    function purchaseItem(uint _itemId) external payable {
        Item storage item = items[_itemId];
        require(item.available, "Item is not available");
        require(msg.value == item.price, "Incorrect price");
        require(msg.sender != item.seller, "Seller cannot buy their own item");

        item.available = false; // Mark as purchased
        item.seller.transfer(msg.value);
        emit ItemPurchased(_itemId, msg.sender, item.price);
    }

    function addReview(uint _itemId, string memory _comment, uint _rating) public {
        require(_rating > 0 && _rating <= 5, "Rating must be between 1 and 5");
        reviews[_itemId].push(Review({
            itemId: _itemId,
            reviewer: msg.sender,
            comment: _comment,
            rating: _rating
        }));
        emit ReviewAdded(_itemId, msg.sender, _rating);
    }

    function getItem(uint _itemId) public view returns (Item memory) {
        return items[_itemId];
    }

    function getReviews(uint _itemId) public view returns (Review[] memory) {
        return reviews[_itemId];
    }

    // Function to retrieve the number of items listed in the marketplace
    function getItemCount() public view returns (uint) {
        return itemCount;
    }

    // Function to retrieve the list of reviews for an item
    function getReviewCount(uint _itemId) public view returns (uint) {
        return reviews[_itemId].length;
    }
}