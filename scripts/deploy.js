const hre = require("hardhat");

async function main() {
  // Deploying vehicle template contract
  const vehicleContractFactory = await hre.ethers.getContractFactory("vehicle");
  const vehicleContract = await vehicleContractFactory.deploy();

  await vehicleContract.deployed();

  // Deploying vehicle manager
  const managerContractFactory = await hre.ethers.getContractFactory("manager");
  const managerContract = await managerContractFactory.deploy(vehicleContract.address);

  await managerContract.deployed();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});