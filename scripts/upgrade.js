const { ethers, upgrades } = require("hardhat");

async function main() {
  const Mytoken2 = await ethers.getContractFactory("Mytoken1");
  console.log("Upgrading Mytoken1...");
  await upgrades.upgradeProxy(
    "0x64A35EB225fEDddEB3426127ae54f7Eca5aF4CB2",
    Mytoken2
  );
  console.log("Upgraded Successfully");
}

main();
