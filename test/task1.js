const { expect } = require("chai");
const hre = require("hardhat")
// const { describe, it } = require("mocha")

describe("测试测试", async () => {
    const { ethers } = hre
    let MyVotingContract;
    let acc1, acc2;
    beforeEach(async () => {
        [acc1, acc2] = await ethers.getSigners()


    })

    it("验证Voting", async () => {
        const MyVoting = await ethers.getContractFactory("Voting")
        // 指定acc2账户部署
        // MyVotingContract = await MyVoting.connect(acc2).deploy()

        // 默认 await ethers.getSigners() 首个账户部署，这里指的是acc1
        MyVotingContract = await MyVoting.deploy()

        MyVotingContract.waitForDeployment()
        // 投票
        await MyVotingContract.vote(acc1, 2);
        await MyVotingContract.vote(acc2, 3);

        //  获取投票数量
        const a1 = await MyVotingContract.getVotes(acc1)
        const a2 = await MyVotingContract.getVotes(acc2)

        console.log("a1票数=====", a1);
        console.log("a2票数=====", a2);


        // // 清空票数

        await MyVotingContract.resetVotes(acc1);



        // 检查清空后 的票数
        const aa1 = await MyVotingContract.getVotes(acc1)
        const aa2 = await MyVotingContract.getVotes(acc2)

        console.log(aa1, aa2);


        // 反转字符串 (Reverse String)
        //  输入汉字会有问题
        const ReverseStr = await MyVotingContract.ReverseStr("asd")
        console.log("ReverseStr", ReverseStr);

        // // 罗马数字转整数
        const romanToIntVal = await MyVotingContract.romanToInt("MC")
        console.log("romanToIntVal", romanToIntVal);
        // // 整数转罗马数字
        const intToRomanVal = await MyVotingContract.intToRoman(1929)
        console.log("intToRomanVal", intToRomanVal);

        // 合并2个有序的数组
        const mergeSortedArrays = await MyVotingContract.mergeSortedArrays([1, 44, 312, 666], [2, 4, 6])
        console.log("mergeSortedArrays", mergeSortedArrays);
        console.log("mergeSortedArrays", Array.isArray(mergeSortedArrays));

        // 二分查找
        // const binarySearchVal = await MyVotingContract.binarySearch(mergeSortedArrays, 44);
        const binarySearchVal = await MyVotingContract.binarySearch([1, 44, 312, 666], 44);
        console.log("binarySearchVal", binarySearchVal);
    })


})