import { ethers, upgrades } from "hardhat";

async function main() {
  const GFTrain = await ethers.getContractFactory("GFTrain");
  console.log("Deploying GFTrain...");
  const gftrain = await upgrades.deployProxy(GFTrain, []);

  await gftrain.deployed();
  console.log("GFTrain deployed to:", gftrain.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
