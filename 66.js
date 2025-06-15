 const{ expect } = require("chai");
const { ethers } = require("hardhat");

describe("BeggingContract", function () {
  let contract;
  let owner, donor1, donor2;

  beforeEach(async () => {
    [owner, donor1, donor2] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory("BeggingContract");
    contract = await Contract.deploy();
  });

  it("应正确设置合约所有者", async () => {
    expect(await contract.owner()).to.equal(owner.address);
  });

  it("应记录捐赠金额", async () => {
    const amount = ethers.utils.parseEther("1");
    await donor1.sendTransaction({to: contract.address, value: amount});
    expect(await contract.getDonation(donor1.address)).to.equal(amount);
  });

  it("应拒绝零金额捐赠", async () => {
    await expect(donor1.sendTransaction({
      to: contract.address,
      value: 0
    })).to.be.reverted;
  });

  it("应允许所有者提取资金", async () => {
    await donor1.sendTransaction({to: contract.address, value: ethers.utils.parseEther("0.5")});
    await donor2.sendTransaction({to: contract.address, value: ethers.utils.parseEther("1")});
    
    const ownerBalanceBefore = await ethers.provider.getBalance(owner.address);
    const tx = await contract.connect(owner).withdraw();
    const receipt = await tx.wait();
    const gasUsed = receipt.gasUsed.mul(tx.gasPrice);
    
    const expectedBalance = ownerBalanceBefore.add(ethers.utils.parseEther("1.5")).sub(gasUsed);
    expect(await ethers.provider.getBalance(owner.address)).to.be.closeTo(
      expectedBalance,
      ethers.utils.parseEther("0.01")
    );
  });

  it("应拒绝非所有者提款", async () => {
    await expect(contract.connect(donor1).withdraw())
      .to.be.revertedWith("Only owner can withdraw");
  });
});
