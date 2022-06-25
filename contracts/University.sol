//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract University {
    //University Name
    string public name;

    //address of the university contract maker
    address public admin;

    //tracks the approval status for students for lending and borrowing in
    //universities pool
    mapping(address => bool) public approvalStatus;

    //token issued by university which can be used as collateral
    address public tokenIssued;

    //list of all dipositors
    address[] public reservesList;

    //tracks all the funds in lending pool by depositors
    mapping(address => uint256) lendingPool;
    //Total Liquidity deposited to lending pool
    uint256 public totalLendingReserve;

    // monthly intrest in percentage
    uint32 public monthlyIntrest;

    constructor(
        string memory _name,
        address token,
        uint32 intrest
    ) {
        monthlyIntrest = intrest;
        name = _name;
        tokenIssued = token;
        admin = msg.sender;
    }

    function approveStudent(address student) public {
        require(msg.sender == admin);
        require(approvalStatus[student] == false);
        approvalStatus[student] = true;
    }

    function deposit(uint256 amount) public returns (bool) {
        require(msg.sender == admin || approvalStatus[msg.sender] == true);
        bool status = IERC20(msg.sender).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        require(status == true);
        lendingPool[msg.sender] = lendingPool[msg.sender] + amount;
        totalLendingReserve = totalLendingReserve + amount;
        return (true);
    }
}
