const hre = require("hardhat");

async function main() {
  // Deploying vehicle template contract
  const vehicleContractFactory = await hre.ethers.getContractFactory("vehicle");
  const vehicleContract = await vehicleContractFactory.deploy();

  await vehicleContract.deployed();

  // Deploying vehicle manager
  const managerContractFactory = await hre.ethers.getContractFactory("manager");
  const managerContract = await managerContractFactory.deploy(vehicleContract.address);

  const manager = await managerContract.deployed();

  await manager.add_vehicle("0xa2e8315cB403625c68D5Ed5666EB3bf481BFD53F", "waucvafr5ba024850", "Audi S5 2011");

  const managerAddress = manager.address;
  const vehicles = await manager.search_my_vehicles();

  console.log(managerAddress);
  console.log(vehicles[0]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});