
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Bank {
// mapping to track user balances
    mapping(address => uint256) public userBalance;

// events 
event Deposited(address user , uint256 amount);
event withdrawed(address user, uint256 amount);
event Transffered (address to , uint256 amount);
   

    // Deposit Eth 
    function deposit() public payable {
        uint256 amount = msg.value;
        require(amount < type(uint256).max, "Amount too large");
        require(amount > 0, "Amount too small");
        userBalance[msg.sender] += amount;
        emit Deposited(msg.sender,amount);
    }


// withdraw Eth
    function withdraw(uint256 amount) public {
        require(userBalance[msg.sender] >= amount, "Insufficient balance");
         userBalance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
       emit withdrawed(msg.sender,amount);
    }

// transfer Eth to recipient
     function send(uint256 amount, address payable recipient) public {
        require(recipient != address(0), "Invalid recipient address");
        require(userBalance[msg.sender] >= amount, "Insufficient balance");
        userBalance[msg.sender] -= amount;
        userBalance[recipient] += amount;
        emit Transffered( recipient, amount);
    }

 // view user Eth balance
    function viewBalance() public view returns (uint256) {
        return userBalance[msg.sender];
    }

  
}