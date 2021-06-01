async function main() {
    const Dbilia = artifacts.require("DbiliaToken");

    const DbiliaTokenContract = await Dbilia.new("DbiliaNFTToken", "ERC721", "0x4B934508E3c610370E0a822200B357300F0ec608");
    console.log("Contract address", DbiliaTokenContract.address);
  }
  
main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error);
    process.exit(1);
});