/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-vyper");
require('hardhat-deploy');
require("@nomiclabs/hardhat-ethers");
module.exports = {
  defaultNetwork: "ganache",
  networks: {
    hardhat: {
    },
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        "0x9f58c933565421bc5c7c17a49f724bd792f3aace229272ed4e12cbaa25b9f972", 
        "0xe2f227b9b63c121d80c33713e4883a0b81a18d87e44d64eeb26af5908b16b400", 
        "0xfb76b6360e3222ad00563ca8799ee2c3ba906df2b28e6f516b7490ab558157b3",
        "0x1aafd6f3474086266283c15987913499a9284f690000e655f0d65ef9ac442fc3",
        "0xf57fc21185f3f2595b385793fc2353f7930eb7c7def9619585c95620e0262753",
        "0xafbbbcf5a764496d7965c153d33a47dbe5cda391cd66c3558032ab2f4e2fe5f9",
        "0x47cd07ec731b6818ee59ece9067be5d8c62f39ba174eb50d6f22da096a6ee6b6",
        "0x4a4576fcf77643fef4952eafd05472a6443d51fcc83e8675ab08a15aa87c634d",
        "0xecfb80c5600be5dc7455100240f05d2f013bdd1e8716b869e03ff39b2c44d4b9",
        "0xce7919d1f04570abaf42271d3dae28c0f1e270b5f2bdd918e31c43d6fde3a125"
      ]
    }
  },
  solidity: "0.8.17",
  vyper: {
    version: "0.3.4",
  },
};
