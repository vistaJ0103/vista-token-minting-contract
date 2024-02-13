const { ethers, upgrades } = require("hardhat"); 

async function main() { 
  const Mytoken1 = await ethers.getContractFactory("Mytoken1"); 
  const myToken = await upgrades.deployProxy(Mytoken1, [], { initializer: "initialize" }); 
  // await myToken.deployed(); 
  console.log("MyToken deployed to:", myToken.target); 
} 

main().then(() => process.exit(0))
.catch(error => { 
  console.error(error); 
  process.exit(1); 
}); 