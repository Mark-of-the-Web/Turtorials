
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import {Bank} from "../src/Bank.sol";

contract SimpleBankTest is Test {
    Bank public bank;
    // create users 
    address Alice = vm.addr(0x123);
    address Bob = vm.addr(0xdead);
    address Carol = vm.addr(0xbeef);
    uint256 amount = 100 ether;

// Setup the test environment
    function setUp() public {
   // Deploy the  Bank contract
        bank = new Bank();
   // give some ether to test users 
        vm.deal(Alice, 100 ether);
        vm.deal(Bob, 100 ether);
        vm.deal(Carol, 100 ether);
    }

    function testDepositAndWithdraw() public {
        vm.startPrank(Alice);
        // check the balance of Alice before deposit 
        assertEq(Alice.balance, 100 ether);
        // deposit ether 
        bank.deposit{value: amount}();
        // check  the balance of alice in the contract 
        assertEq(bank.userBalance(Alice), amount);
        // check the balance of Alice has 0 balance after  deposit 
        assertEq(Alice.balance,  0);
        // withdraw funds 
        bank.withdraw(amount);
       // check  the balance of alice in the contract is now  0
        assertEq(bank.userBalance(Alice), 0);
        // check the balance of Alice has 0 balance after  deposit 
        assertEq(Alice.balance,  100 ether);
        vm.stopPrank();
    }

    function testTransfer() public {
      vm.startPrank(Alice);
        // check the balance of Alice before deposit 
        assertEq(Alice.balance, 100 ether);
        // deposit ether 
        bank.deposit{value: amount}();
        // check  the balance of alice in the contract 
        assertEq(bank.userBalance(Alice), amount);
        // check the balance of Alice has 0 balance after  deposit 
        assertEq(Alice.balance,  0);
        // transfer some funds to bob
        bank.send(50 ether, payable(Bob));
        // check the balance of Alice in the contract has decreased
        assertEq(bank.userBalance(Alice), amount - 50 ether);
        // check the balance of Bob in the contract has increased
        assertEq(bank.userBalance(Bob), 50 ether);


}


function test_CannotWithdrawMoreThanDeposited() public {
         vm.startPrank(Carol);
        // check the balance of Carol before deposit 
        assertEq(Carol.balance, 100 ether);
        // deposit ether 
        bank.deposit{value: amount}();
        // check  the balance of Carol in the contract 
        assertEq(bank.userBalance(Carol), amount);
        // check the balance of Carol has 0 balance after  deposit 
        assertEq(Carol.balance,  0);
        // withdraw funds 
        vm.expectRevert("Insufficient balance");
        bank.withdraw(200 ether);
}


function test_CannotTransferMoreThanDeposited() public {
             vm.startPrank(Carol);
        // check the balance of Carol before deposit 
        assertEq(Carol.balance, 100 ether);
        // deposit ether 
        bank.deposit{value: amount}();
        // check  the balance of Carol in the contract 
        assertEq(bank.userBalance(Carol), amount);
        // check the balance of Carol has 0 balance after  deposit 
        assertEq(Carol.balance,  0);
        // transfer funds 
        vm.expectRevert("Insufficient balance");
        bank.send(200 ether, payable(Bob));
}



}