const { Wallet } = require('ethers');
require('dotenv').config();

async function main() {
  const mnemonic = process.env.PRIVATE_KEY;
  const wallet = Wallet.fromPhrase(mnemonic);
  console.log('Private Key:', wallet.privateKey);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 