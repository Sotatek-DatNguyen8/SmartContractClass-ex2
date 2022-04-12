// import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts with the account: ${deployer.address}`);
  const balance = await deployer.getBalance();
  console.log(`Account balance: ${balance.toString()}`);
  const Example2 = await ethers.getContractFactory("DucDatToken");
  const example2 = await Example2.deploy(
    "0x264E29FDF6740616b1bBb9B47142e4256D0c345f"
  );
  console.log(`Token address: ${example2.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
