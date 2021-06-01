const { artifacts } = require("hardhat");
const Dbilia = artifacts.require("DbiliaToken");
const { expect } = require("chai");
contract("Dbilia", accounts => {
    let DbiliaTokenContract;
    let [ deployer, dbilia, user ] = accounts;

    before(async function () {
        DbiliaTokenContract = await Dbilia.new("Dbilia", "ERC721", dbilia);
    });

    it("Only dbilia account can call mintWithUSD", async function() {
        try {
            await DbiliaTokenContract.mintWithUSD(dbilia, 1, 1, "w");
        } catch (err) {
            expect(err.message).to.equal("VM Exception while processing transaction: revert !dbilia");
        }
    });

    it("Dbilia calls mintWithUSD", async function() {
        await DbiliaTokenContract.mintWithUSD(dbilia, 1, 1, "w", {from: dbilia});
        let balance = await DbiliaTokenContract.balanceOf(dbilia);
        let owner = await DbiliaTokenContract.ownerOf(1);
        expect(balance.toString()).to.equal("1");
        expect(owner).to.equal(dbilia);
    });

    it("Fail if duplicate cardId", async function() {
        let payAmount = web3.utils.toBN(1 * 10 ** 18);
        let cardId = 1;
        let edition = 1;
        let tokenUri = "";
        try {
            await DbiliaTokenContract.mintWithETH(cardId, edition, tokenUri, {from: user, value: payAmount});
        } catch (err) {
            expect(err.message).to.equal("VM Exception while processing transaction: revert CardId is already exist");
        }
    });

    it("User calls mintWithETH and check balance", async function() {
        let payAmount = web3.utils.toBN(1 * 10 ** 18);
        let cardId = 2;
        let edition = 1;
        let tokenUri = "";
        await DbiliaTokenContract.mintWithETH(cardId, edition, tokenUri, {from: user, value: payAmount});
        let balance = await DbiliaTokenContract.balanceOf(user);
        let owner = await DbiliaTokenContract.ownerOf(2);
        expect(balance.toString()).to.equal("1");
        expect(owner).to.equal(user);
    });
});