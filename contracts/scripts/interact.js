const hre = require("hardhat");

async function main() {
  // 获取合约地址（这里需要替换为实际部署的地址）
  const contractAddress = "YOUR_CONTRACT_ADDRESS";
  
  const SimpleStorage = await hre.ethers.getContractFactory("SimpleStorage");
  const simpleStorage = await SimpleStorage.attach(contractAddress);

  // 存储新值
  console.log("Storing new value...");
  const tx = await simpleStorage.store(42);
  await tx.wait();
  console.log("Value stored!");

  // 读取值
  console.log("Reading value...");
  const value = await simpleStorage.retrieve();
  console.log("Current value:", value.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 