const { expect } = require("chai");
const hre = require("hardhat")
// const { describe, it } = require("mocha")

describe("测试测试task2", async () => {
    const { ethers } = hre
    const initialSupply = 10000// 发行10000枚代币

    let task2Erc20;

    // 部署到 sepolia 测试网络
    //  npx hardhat ignition deploy ./ignition/modules/Lock.js --network sepolia --reset
    let acc1, acc2;
    beforeEach(async () => {
        [acc1, acc2] = await ethers.getSigners()

        const erc20Fac = await ethers.getContractFactory("Erc20Task2");
        task2Erc20 = await erc20Fac.deploy(initialSupply);
        await task2Erc20.waitForDeployment()

        const addr = await task2Erc20.getAddress()

        expect(addr).to.length.greaterThan(0)

        console.log("addr", addr);


    })

    it("验证erc20代币", async () => {
        const name = await task2Erc20.name()
        const symbol = await task2Erc20.symbol()
        const decimals = await task2Erc20.decimals()

        expect(name).to.equal('ERC20TEST')
        expect(symbol).to.equal('ECT')

        console.log("decimals", decimals);

        const balanceOfAcc1 = await task2Erc20.balanceOf(acc1)
        const balanceOfAcc2 = await task2Erc20.balanceOf(acc2)

        console.log(balanceOfAcc1, balanceOfAcc2);


        // expect(balanceOfAcc1).to.equal(initialSupply)
        // const res = await task2Erc20.transfer(acc2, initialSupply / 2)
        // console.log("res");
        // const balanceOfAcc2 = await task2Erc20.balanceOf(acc2)
        // console.log("balanceOfAcc2", balanceOfAcc2);
        // expect(balanceOfAcc2).to.equal(initialSupply / 2)

    })


})