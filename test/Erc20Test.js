const { expect } = require("chai");
const hre = require("hardhat")
// const { describe, it } = require("mocha")

describe("测试测试", async () => {
    const { ethers } = hre

    const initialSupply = 10000 // 发行10000枚代币

    let MyTokenContract;

    let acc1, acc2;


    beforeEach(async () => {

        [acc1, acc2] = await ethers.getSigners()


        const MyToken = await ethers.getContractFactory("Erc20_openz")

        MyTokenContract = await MyToken.deploy(initialSupply)

        MyTokenContract.waitForDeployment()

        const addr = await MyTokenContract.getAddress()

        expect(addr).to.length.greaterThan(0)

        console.log("addr", addr);

    })

    it("验证合约账户信息", async () => {
        const name = await MyTokenContract.name()
        const symbol = await MyTokenContract.symbol()
        const decimals = await MyTokenContract.decimals()

        expect(name).to.equal('MyToken')
        expect(symbol).to.equal('MTK')

        console.log("decimals", decimals);

    })

    it("测试转账", async () => {

        // const balanceOfAcc1 = await MyTokenContract.balanceOf(acc1)
        // const balanceOfAcc2 = await MyTokenContract.balanceOf(acc2)

        // expect(balanceOfAcc1).to.equal(initialSupply)
        const res = await MyTokenContract.transfer(acc2, initialSupply / 2)
        console.log("res");
        const balanceOfAcc2 = await MyTokenContract.balanceOf(acc2)
        console.log("balanceOfAcc2", balanceOfAcc2);
        expect(balanceOfAcc2).to.equal(initialSupply / 2)
    })
})