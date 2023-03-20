module.exports = async ({getNamedAccounts, deployments}) => {
    const {deploy} = deployments;
    const {deployer} = await getNamedAccounts();
    await deploy('contrato', {
      from: deployer,
      args: [deployer, "ABC0000"],
      log: true,
    });
  };
module.exports.tags = ['contrato'];