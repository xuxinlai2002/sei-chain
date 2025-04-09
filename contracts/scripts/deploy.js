const hre = require("hardhat");
const { exec } = require("child_process");

const CW20_BASE_WASM_LOCATION = "../cw20_base.wasm";

async function main() {
    const SimpleStorage = await hre.ethers.getContractFactory("SimpleStorage");
    const simpleStorage = await SimpleStorage.deploy();

    await simpleStorage.deployed();

    console.log("SimpleStorage deployed to:", simpleStorage.address);
}

async function fundDeployer(deployerAddress) {
    // Wrap the exec function in a Promise
    await new Promise((resolve, reject) => {
        exec(`seid tx evm send ${deployerAddress} 10000000000000000000 --from admin`, (error, stdout, stderr) => {
            if (error) {
                console.log(`error: ${error.message}`);
                reject(error);
                return;
            }
            if (stderr) {
                console.log(`stderr: ${stderr}`);
                reject(new Error(stderr));
                return;
            }
            resolve();
        });
    });
}

async function deployWasm() {
    // Wrap the exec function in a Promise
    let codeId = await new Promise((resolve, reject) => {
        exec(`seid tx wasm store ${CW20_BASE_WASM_LOCATION} --from admin --gas=5000000 --fees=1000000usei -y --broadcast-mode block`, (error, stdout, stderr) => {
            if (error) {
                console.log(`error: ${error.message}`);
                reject(error);
                return;
            }
            if (stderr) {
                console.log(`stderr: ${stderr}`);
                reject(new Error(stderr));
                return;
            }

            // Regular expression to find the 'code_id' value
            const regex = /key: code_id\s+value: "(\d+)"/;

            // Searching for the pattern in the string
            const match = stdout.match(regex);

            let cId = null;
            if (match && match[1]) {
                // The captured group is the code_id value
                cId = match[1];
            }

            console.log(`cId: ${cId}`);
            resolve(cId);
        });
    });

    return codeId;
}

async function getAdmin() {
    // Wrap the exec function in a Promise
    let adminAddr = await new Promise((resolve, reject) => {
        exec(`seid keys show admin -a`, (error, stdout, stderr) => {
            if (error) {
                console.log(`error: ${error.message}`);
                reject(error);
                return;
            }
            if (stderr) {
                console.log(`stderr: ${stderr}`);
                reject(new Error(stderr));
                return;
            }
            resolve(stdout.trim());
        });
    });
    return adminAddr;
}

async function instantiateWasm(codeId, adminAddr) {
    // Wrap the exec function in a Promise
    let contractAddress = await new Promise((resolve, reject) => {
        exec(`seid tx wasm instantiate ${codeId} '{ "name": "BTOK", "symbol": "BTOK", "decimals": 6, "initial_balances": [ { "address": "${adminAddr}", "amount": "1000000" } ], "mint": { "minter": "${adminAddr}", "cap": "99900000000" } }' --label cw20-test --admin ${adminAddr} --from admin --gas=5000000 --fees=1000000usei -y --broadcast-mode block`, (error, stdout, stderr) => {
            if (error) {
                console.log(`error: ${error.message}`);
                reject(error);
                return;
            }
            if (stderr) {
                console.log(`stderr: ${stderr}`);
                reject(new Error(stderr));
                return;
            }
            const regex = /_contract_address\s*value:\s*(\w+)/;
            const match = stdout.match(regex);
            if (match && match[1]) {
                resolve(match[1]);
            } else {
                reject(new Error('Contract address not found'));
            }
        });
    });
    return contractAddress;
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
