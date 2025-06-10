require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",

  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/fa82276745b54e328b4280aba534a1fa`,
      accounts: ["28cca5039541cfc10dd5ad9c1268e09e3089507e9510f418bf212dece269d245"],

    }
  }
};
