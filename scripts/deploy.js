
const hre = require("hardhat");

async function main() {
 

  const Chat = await hre.ethers.getContractFactory("chatApp");
  const chat = await Chat.deploy();

  await chat.deployed();

  console.log(
    `Chat contract deployed to ${chat.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
