require("dotenv").config({ path: ".env" });
const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('TicketNFTGenerator');
    const nftContract = await nftContractFactory.deploy(process.env.MAX_SUPPLY,
      process.env.INITIAL_MINT_PRICE,
      process.env.URL_COMMON,
      process.env.URL_RARE,
      process.env.URL_SUPER_RARE,
      process.env.UPPER_LIMIT_COMMON,
      process.env.UPPER_LIMIT_RARE,
      process.env.CHAINLINK_SUBSCRIPTION_ID,
      process.env.CHAINLINK_VRF_COORDINATOR,
      process.env.CHAINLINK_KEY_HASH);
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);
    let transaction = await nftContract.mintTicket({value: process.env.INITIAL_MINT_PRICE});
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