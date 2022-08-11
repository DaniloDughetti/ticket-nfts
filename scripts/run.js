require("dotenv").config({ path: ".env" });
const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('TicketNFTGenerator');
    const nftContract = await nftContractFactory.deploy(process.env.MAX_SUPPLY);
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);
    let transaction = await nftContract.mintTicket();
    let tokenList = await nftContract.getTokenList();
    await transaction.wait();
    await tokenList.wait();
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