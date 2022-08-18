require("dotenv").config({ path: ".env" });
const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('TicketNFTGenerator');
    const nftContract = await nftContractFactory.deploy(process.env.MAX_SUPPLY, process.env.INITIAL_MINT_PRICE);
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();