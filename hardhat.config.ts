import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 7777,
      },
    }
  },
  networks: {
    'bsc': {
      url: process.env.BSC_MAINNET_URL,
      accounts: [process.env.PRIVATE_KEY ?? ""],
      gasPrice: 5_000_000_000
    },
    'testnet': {
      url: process.env.BSC_TESTNET_URL,
      accounts: [process.env.PRIVATE_KEY ?? ""],
      gasPrice: 5_000_000_000
    },
  }
};

export default config;
