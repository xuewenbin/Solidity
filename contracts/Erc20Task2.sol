// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
import "hardhat/console.sol";

//ERC20 同质化代币，每个代币的本质或性质都是相同
//ETH 是原生代币，它不是ERC20代币,它们两是不能协同工作。所以需要将ETH转换成WETH(ERC20)
//ERC20 必须实现相应的接口(规范),参见 https://eips.ethereum.org/EIPS/eip-20

//totalSupply 代币发行总供应量，它即可以固定不变，又可以根据业务需求而改变
//totalSupply 代币发行总供应量是否可变，取决于合约是否存在mint或burn函数/方法
//balanceOf(owner) 获取某个账户的余额，所有账户余额的总和必须等于totalSupply

//approve 授权一定数量的代币给第三方/交易所/代理人。注意，是授权而不是发送代币给第三方
//approve 必须包含3个参数，Owner:谁授权代币给第三方，Spender:第三方/交易所/代理人,Amount:授权数额
//allowance 保存approve方法的3项数据

//transfer 转账，接收2个参数，from:msg.sender; to:转入; amount:金额
//transferFrom 转账，接收3个参数，from:转出; to:转入; amount:金额
//transfer与transferFrom使用场景不一样，transfer用在本合约转账，transferFrom用在第三方/去中心交易所/代理人

//event Approval与Transfer 将交易等日志信息写入区块链，非常重要

//V1
interface IERC20V1 {
    //event Approval与Transfer 将交易等日志信息写入区块链，非常重要
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
    //event Approval与Transfer 将交易等日志信息写入区块链，非常重要
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    //对应状态变量totalSupply 代币发行总供应量
    function totalSupply() external view returns (uint256);

    //balanceOf(owner) 获取某个账户的余额
    function balanceOf(address owner) external view returns (uint256);

    //approve 授权一定数量的代币给第三方/交易所/代理人。注意，是授权而不是发送代币给第三方
    //approve 必须包含3个参数，Owner:谁授权代币给第三方，Spender:第三方/交易所/代理人,Amount:授权数额
    function approve(address spender, uint amount) external returns (bool);

    //allowance 保存approve方法的3项数据
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    //transfer 转账，接收2个参数，from:msg.sender; to:转入; amount:金额
    function transfer(address to, uint amount) external returns (bool);

    //transferFrom 转账，接收3个参数，from:转出; to:转入; amount:金额
    function transferFrom(
        address from,
        address to,
        uint amount
    ) external returns (bool);
}

contract Erc20Task2 is IERC20V1 {
    string public constant name = "ERC20TEST";
    string public constant symbol = "ECT";
    uint8 public constant decimals = 18;
    //totalSupply 代币发行总供应量
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public approvedOfbalance;
    address public _owner;

    mapping(address => mapping(address => uint256)) public allowance;

    constructor(uint256 _initTotalSupply) {
        _owner = msg.sender;
        //预挖给创建者代币
        mint(msg.sender, _initTotalSupply);
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable:caller is not the owner");
        _;
    }

    //挖掘出新代币以及挖给那个地址
    //合约创建者调用
    function mint(address to, uint256 amount) public onlyOwner {
        totalSupply = totalSupply += amount;
        balanceOf[to] = balanceOf[to] += amount;
    }

    //燃烧自己的代币
    function burn(uint256 amount) public {
        address from = msg.sender;
        balanceOf[from] = balanceOf[from] -= amount;
        totalSupply = totalSupply -= amount;
    }

    function _approve(address owner, address spender, uint amount) private {
        allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount); // 调用 事件，将交易等日志信息写入区块链
    }

    function approve(address spender, uint amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        approvedOfbalance[spender] += amount;
        return true;
    }

    function _transfer(address from, address to, uint amount) private {
        balanceOf[from] = balanceOf[from] -= amount;
        balanceOf[to] = balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }

    function transfer(address to, uint amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint amount
    ) external returns (bool) {
        uint256 currentAllowance = allowance[from][msg.sender];
        require(currentAllowance >= amount, "ERC20: insufficient allowance");
        allowance[from][msg.sender] = currentAllowance -= amount;
        //console.log("msg.sender ->",address(msg.sender));
        _transfer(from, to, amount);
        return true;
    }
}

//建议去中心化交易所
contract Dex {
    address public erc20V1;

    constructor(address _erc20V1) {
        erc20V1 = _erc20V1;
    }

    function transferFromTo(address to, uint amount) external {
        IERC20V1(erc20V1).transferFrom(msg.sender, to, amount);
    }

    function transferTo(address to, uint amount) external {
        IERC20V1(erc20V1).transfer(to, amount);
    }
}
