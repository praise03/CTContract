const { run, network } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const CTContract = await ethers.getContractFactory("CTMaticContract");
    const CTMaticContract = await CTContract.deploy();
  
    console.log("CTMatic contract deployed at: ", CTMaticContract.address);


    if(!["hardhat", "localhost"].includes(network.name) && (process.env.MUMBAI_API_KEY)){
        console.log("Verifying contract.....")
        try{
            await run("verify:verify", {
                address: "0xd4203C458104C98328Ba83e2F2E4cA8C6C4e121C",
            })
        }catch (e) {
        if (e.message.toLowerCase().includes("already verified")){
            console.log("Contract Already Verified")
        }else{ console.log(e) }
        }
    }
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });

