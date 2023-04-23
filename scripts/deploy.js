async function main() {
    // Deploying vehicle template contract
  const vehicleContractFactory = await hre.ethers.getContractFactory("vehicle");
  const vehicleContract = await vehicleContractFactory.deploy();

  await vehicleContract.deployed();

  // Deploying vehicle manager
  const managerContractFactory = await hre.ethers.getContractFactory("manager");
  const managerContract = await managerContractFactory.deploy(vehicleContract.address);

  const manager = await managerContract.deployed();
  console.log(manager.address);
}
main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error);
    process.exit(1);
});