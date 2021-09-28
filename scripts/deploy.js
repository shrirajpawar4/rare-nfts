const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
};

main()
 .then(() => process.exit(0))
 .catch((error) => {
     console.log(error);
     process.exit(1)
 })