const { expect } = require("chai");
const hre = require("hardhat")
// const { describe, it } = require("mocha")

describe("测试测试task2", async () => {
    const { ethers } = hre
    const initialSupply = 10000// 发行10000枚代币



    // 部署到 sepolia 测试网络
    //  npx hardhat ignition deploy ./ignition/modules/Lock.js --network sepolia --reset
    let acc1, acc2;
    beforeEach(async () => {
        [acc1, acc2] = await ethers.getSigners()




    })

    // it("验证erc20代币", async () => {
    //     let task2Erc20;
    //     const erc20Fac = await ethers.getContractFactory("Erc20Task2");
    //     task2Erc20 = await erc20Fac.deploy(initialSupply);
    //     await task2Erc20.waitForDeployment()

    //     const addr = await task2Erc20.getAddress()

    //     expect(addr).to.length.greaterThan(0)

    //     console.log("addr", addr);
    //     const name = await task2Erc20.name()
    //     const symbol = await task2Erc20.symbol()
    //     const decimals = await task2Erc20.decimals()

    //     expect(name).to.equal('ERC20TEST')
    //     expect(symbol).to.equal('ECT')

    //     console.log("decimals", decimals);

    //     let balanceOfAcc1 = await task2Erc20.balanceOf(acc1)
    //     let balanceOfAcc2 = await task2Erc20.balanceOf(acc2)

    //     // console.log(balanceOfAcc1, balanceOfAcc2);


    //     // expect(balanceOfAcc1).to.equal(initialSupply)
    //     const res = await task2Erc20.transfer(acc2, initialSupply / 2)
    //     console.log("res");
    //     balanceOfAcc2 = await task2Erc20.balanceOf(acc2)
    //     console.log("balanceOfAcc2", balanceOfAcc2);
    //     expect(balanceOfAcc2).to.equal(initialSupply / 2)


    //     await task2Erc20.approve(acc1, 2000)
    //     await task2Erc20.approve(acc2, 2000)

    //     await task2Erc20.transferFrom(acc1, acc2, 1000)
    //     balanceOfAcc1 = await task2Erc20.balanceOf(acc1)
    //     balanceOfAcc2 = await task2Erc20.balanceOf(acc2)
    //     console.log("balanceOfAcc1", balanceOfAcc1, "balanceOfAcc2", balanceOfAcc2);
    // })

    // it("验证erc721代币", async () => {
    //     let task2Erc721;
    //     const erc720Fac = await ethers.getContractFactory("Erc721Task2");
    //     task2Erc721 = await erc720Fac.deploy();
    //     await task2Erc721.waitForDeployment()

    //     const addr = await task2Erc721.getAddress()
    //     console.log("addr", addr);
    //     const getAddr = await task2Erc721.getAddr()
    //     console.log("getAddr", getAddr);

    //     const tokenId = await task2Erc721.mintNFT(acc1, 'ipfs://bafkreid2sgvjkdhyntwqst72tnwwjepqwx6yzqjlvteuknpyhqe6rmiewq');

    //     console.log("tokenId", tokenId);



    // })
    it("验证捐赠", async () => {
        let BeggingContractTask2;
        const beg = await ethers.getContractFactory("BeggingContractTask2");
        BeggingContractTask2 = await beg.deploy();
        await BeggingContractTask2.waitForDeployment()

        const addr = await BeggingContractTask2.getAddress()
        console.log("addr", addr);

        // 应记录捐赠金额

        const amount = ethers.parseEther("1");

        console.log("amount==========", amount);

        await acc2.sendTransaction({ to: addr, value: amount });
        const _d = await BeggingContractTask2.getDonation(acc2)
        console.log("acc2捐献了", _d);

        expect(_d).to.equal(amount);

        const acc1BalanceBefore = await ethers.provider.getBalance(acc1);

        console.log("acc1BalanceBefore====提取前的金额", ethers.formatEther(acc1BalanceBefore));

        await BeggingContractTask2.withdraw();
        const acc1expectedBalance = await ethers.provider.getBalance(acc1);

        console.log("acc1BalanceBefore====提取后的金额", ethers.formatEther(acc1expectedBalance));

    })





})