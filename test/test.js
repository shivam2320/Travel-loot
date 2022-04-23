const { ethers } = require('hardhat');
const { expect } = require('chai');
const { inputToConfig } = require('@ethereum-waffle/compiler');

describe("TravelLoot Testing", () => {

    let owner;
    let addr1;
    let TravelLoot;
    let travelLoot;

    beforeEach(async () => {
        [owner, addr1] = await ethers.getSigners();
        TravelLoot = await ethers.getContractFactory("TravelLoot");
        travelLoot = await TravelLoot.deploy();

        await travelLoot.deployed();
    });

    describe("Minting", () => {
        it("Should mint NFTs", async () => {
           await travelLoot.mint(23, {value: ethers.utils.parseEther("30")});
           await travelLoot.mint(232, {value: ethers.utils.parseEther("30")});
           expect(await travelLoot.totalSupply()).to.equal(2);
           expect(await travelLoot.ownerOf(23)).to.equal(owner.address);

           console.log("TokenURI: ",await travelLoot.tokenURI(23));
        });
    });

    describe("Transfers", () => {
        it("Transfer properly", async () => {
            await travelLoot.mint(23, {value: ethers.utils.parseEther("30")});
            await travelLoot.transferFrom(owner.address, addr1.address, 23);
            expect(await travelLoot.balanceOf(addr1.address)).to.equal(1);
        });
    });


});