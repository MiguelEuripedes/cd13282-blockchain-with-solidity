// Import the necessary libraries. 'chai' is used for assertions, and 'ethers' for interacting with Ethereum.
// An assertion is a statement in code that varifies the correctness of condition.
const { expect } = require("chai");
const { ethers } = require("hardhat");

// Describe a test suite for the PromVoting contract. This is a group of tests related to PromVoting functionality.
describe("PromVoting", function () {
  // Declare variables to be used in the test. These will represent deployed contract and user addresses.
  let promVoting; // This variable will hold our deployed PromVoting contract.
  let owner; // This will represent the contract owner in tests.
  let addr1; // This will represent another user.

  // 'beforeEach' is a hook that runs before each test. It's used to set up the environment for each test case.
  // This is ideal for deploying a fresh instance of the contract to ensure tests do not interfere with each other.
  beforeEach(async function () {
    // Get the ContractFactory for PromVoting, which allows us to deploy new instances of the contract.
    const PromVoting = await ethers.getContractFactory("PromVoting");
    // Get signers. Signers represent different accounts that can interact with the contract.
    // This is how you simulate different users interacting with your contract.
    [owner, addr1] = await ethers.getSigners();

    // Deploy a fresh instance of the PromVoting contract before each test, ensuring clean state.
    promVoting = await PromVoting.deploy();
  });

  // Test case: Ensuring a candidate can be added successfully.
  // This is a basic test to verify contract functionality.
  it("Should deploy and add a candidate", async function () {
    // Call the addCandidate function of our contract. With a candidate name.
    await promVoting.addCandidate("Alice");
    // Retrieve the candidate's details. To verify the addition was successful.
    const candidate = await promVoting.candidate();
    // Use Chai's expect method to assert that the candidate's name matches what we added.
    // This is an example of using assertions, to check if the candidate's name matches what we added.
    expect(candidate.name).to.equal("Alice");
  });

  // Test case: Ensuring that voting for a candidate emits an event and increments the vote count.
  // This test contract events and state changes.
  it("Should allow voting and emit an event", async function () {
    // First, add a candidate to vote for.
    await promVoting.addCandidate("Alice");
    // Perform a vote and expect the 'VoteCast' event to be emitted with the candidate's name.
    // This shows how to test for event emissions, a crucial part of contract interaction feedback.
    await expect(promVoting.vote())
      .to.emit(promVoting, "VoteCast")
      .withArgs("Alice");
    // Check if the candidate's vote count is incremented.
    const candidate = await promVoting.candidate();
    expect(candidate.voteCount).to.equal(1);
  });

  // Test case: Verifying that the contract correctly reports the number of votes a candidate has received.
  // This is a example of testing contract output and state.
  it("Should return the correct vote count after voting", async function () {
    // Add a candidate and vote for them.
    await promVoting.addCandidate("Alice");
    await promVoting.vote();
    // Use the getVoteCount function to retrieve the vote count.
    // Check if the getVoteCount function returns the expected vote count.
    expect(await promVoting.getVoteCount()).to.equal(1);
  });
});
