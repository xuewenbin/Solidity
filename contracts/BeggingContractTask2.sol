pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BeggingContractTask2 is Ownable {
    mapping(address => uint256) public donations;

    constructor() Ownable(msg.sender) {}

    // msg.sender‌ 表示当前函数调用者的地址（可能是外部账户或合约账户）
    // address(this) 表示当前合约自身的地址，在部署时确定且不可变

    // 捐赠函数（payable接收ETH）
    function donate() external payable {
        require(msg.value > 0, "Donation amount must be positive");
        // msg.sender‌ 表示当前函数调用者的地址（可能是外部账户或合约账户）
        donations[msg.sender] += msg.value;
    }

    // 查询指定地址的捐赠总额
    function getDonation(address donor) external view returns (uint256) {
        return donations[donor];
    }

    // 仅所有者可调用的提款函数
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // 接收ETH的回退函数（可选）
    receive() external payable {
        donations[msg.sender] += msg.value;
    }

    // fallback() external payable {
    //     donations[msg.sender] += msg.value;
    // }
}
