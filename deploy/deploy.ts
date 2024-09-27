// import { getDefaultProvider } from "ethers";
// import { ContractFactory } from "ethers";
// import { BrowserProvider } from "ethers";
import { network } from "hardhat";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

//import { createTransaction } from "../test/utils";

console.log("Connected to network:", network.name);

const { ethers } = require("hardhat");
const fs = require("fs");

//module.exports = async ({ deployments, ethers }: HardhatRuntimeEnvironment) => {
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deploy, get, getArtifact } = hre.deployments;
    const provider = network.provider; //new ethers.JsonRpcProvider(process.env.localnode);
    const privateKey = process.env.PRIVATE_KEY;
    const signer = new ethers.Wallet(privateKey, provider);
    //console.log(signer.address);
    // try {
    //   const blockNumber = await provider.getBlockNumber();
    //   console.log(`Connected successfully. Current block number is ${blockNumber}`);
    // } catch (error) {
    //   console.error("Error connecting to provider:", error);
    // }

    // // Get the signer from MetaMask`
    // const privateKey = process.env.PRIVATE_KEY;
    // if (!privateKey) {
    //   throw new Error("Private key not found in environment variables");
    // }

    // const signer = new ethers.Wallet(privateKey, provider);

    // // Get the balance of the signer's address
    // const balancezama = await provider.getBalance(signer.address);
    // console.log(`Signer's balance: ${balancezama} Zama for ${signer.address}`);

    // Deploy interface IEngine
    await deploy("IEngine", { from: signer.address, log: true, waitConfirmations: 5 });

    // Deploy interface IGeoInt
    await deploy("IGeoInt", { from: signer.address, log: true, waitConfirmations: 5 });

    // Deploy interface IHQBase
    await deploy("IHQBase", { from: signer.address, log: true, waitConfirmations: 5 });

    // Deploy interface IHumint
    await deploy("IHumint", { from: signer.address, log: true, waitConfirmations: 5 });

    // Deploy interface IOperation 0x7f2517e46D2dd1ABA4D8596A960944Fc44f7E19b zama 0xF25F59cb8D61A232806Bd1C19E74eE38745B1381
    await deploy("IOperation", { from: signer.address, log: true, waitConfirmations: 5 });

    // Deploy interface IOpMetadata 0x2C570cbEb557d564096f3B1Af632002c905BAF82
    //await deploy("IOpMetadata", { from: signer.address, log: true, waitConfirmations: 5 });

    // Deploy library IRMHelper 0x980Fe60c88551E5B4cd675A085767d66c4Ea349F zama 0x64917341B7636bb776231073be1686d42377F153
    await deploy("IRMHelper", { from: signer.address, log: true, waitConfirmations: 5 });

    // Deploy contract IRMRights 0x1861666D9d20B88Cb7bD245ea07FcD082E8Be03F zama 0xF172c9CAF33682F32E08D46a90a4aB91eeC578D9

    // let myPrice = ethers.parseUnits("0.2", "gwei");

    // await deploy("IRMRights", {
    //   from: signer.address,
    //   log: true,
    //   // args: [signer.address],
    //   waitConfirmations: 5,
    //   gasLimit: 10000000,
    //gasPrice: myPrice,
    //});

    // Deploy contract OpMetadata 0x9B962f738090c811c9Ecbd9aE6d47b138bA198A5 zama 0x7b5d4914A8567caBCd36eAEbbCf32970e9B01bb7
    //await deploy("OpMetadata", { from: signer.address, log: true, waitConfirmations: 5 });

    // Deploy contract OpFactory 0x299a751e37cc50732fedCAa142537D6A1161EeBA zama 0x028562ca1E8dCca7aaD39E13906112B95701536a

    // const OpMetadataADDR = await get("OpMetadata");
    // await deploy("OpFactory", {
    //   from: signer.address,
    //   log: true,
    //   args: [OpMetadataADDR.address],
    //   waitConfirmations: 5,
    //   gasLimit: 10000000,
    // });

    // Get OpFactory ABI
    // const OpFactoryArtifact = await getArtifact("OpFactory");
    // const OpFactoryABI = OpFactoryArtifact.abi;
    // Write ABI to file
    // const abiFactPath = "/Volumes/vrona_SSD/IRM.xyz/src/components/CreateOp/opfactabi.json";
    // fs.writeFileSync(abiFactPath, JSON.stringify(OpFactoryABI, null, 2));

    // Get IRMRIGHTS ABI
    // const OpIRMRightsArtifact = await getArtifact("IRMRights");
    // const IRMRightsABI = OpIRMRightsArtifact.abi;
    // Write ABI to file
    // const abiRightPath = "/Volumes/vrona_SSD/IRM.xyz/src/components/RightMgt/irmrightsabi.json";
    // fs.writeFileSync(abiRightPath, JSON.stringify(IRMRightsABI, null, 2));

    // console.log(`ABI saved to ${abiRightPath}`);
};

// module.exports.tags = ["all"];
export default func;
func.tags = ["basic", "all"];
