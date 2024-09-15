// Import Hardhat's runtime environment to use its functionalities.
// Hardhat's environment automatically configures everything to work with the rest
// of Hardhat's features. This includes, crucially, the integration with Ether.js, which
// provides a comprehensive collection of tools to interact with the ethereum Blockchain
const hre = require("hardhat");

// Define an asynchronous main function for deploying our smart contract. Asynchrounous functions 
// are essential for blockchain interactions because they allow us to wait for operations like 
// transactions, which are not instantaneous, to complete.
async function main() {
  // Fetch the ContractFactory for our PromVoting contract.
  // ContractFactory is an abstraction provided by Ethers.ks, via Hardhat, 
  // that allows us to deploy new smart contracts. Think of it as a blueprint
  // for out contract, enabling us to create instances on the Ethereum blockchain.
  const PromVoting = await hre.ethers.getContractFactory("PromVoting");

  // Deploy the contract. This asynchronous operation that sends a transaction to the
  // ethereum network to create a new instance of our contract. We await this operation
  // beacuse it might take some time for the transactions to be mined and for the contract
  // to be deployed.
  const promVoting = await PromVoting.deploy();

  // Log the address of the newly deployed contract. This is useful for verifying deployment
  // and for interacting with the contract afterwards.
  console.log("PromVoting deployed to:", promVoting.address);
}

// Call our Main function to execute the deployment script. We use .then() and
// .catch() to handle the promise returned by the main function. This pattern is
// recommended by Hardhat for handling asynchrounous operations in deployment scripts.
// It ensures that any errors encountered during deployment are caught and handled
// appropriately.
main()
  .then(() => process.exit(0)) // On successful deployment, exit with a status code 0.
  .catch((error) => {
    console.error(error); // Log any errors that occur.
    process.exit(1); // Exit with a status code 1 indicating an error.
  });
