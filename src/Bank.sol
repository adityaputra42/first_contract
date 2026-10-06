// SPDX-License-Identifier:MIT

pragma solidity ^0.8.37;

contract Bank {

  event DepositSuccesfull(address indexed account,uint256 amount);

  event WithdrawSuccesfull(address indexed account,uint256 amount);

  error  depositMissmatch();

  error  amountCantBeZero();

  error  insuficientFunds();

  error  withdrawFailed();

  error  addressNotFound();


  mapping (address => uint256) private accountBalance;

  function deposit(uint256 amount) public payable {
    if(amount<=0) {
      revert amountCantBeZero();
    }

    if(amount!=msg.value){
      revert depositMissmatch();
    }
    accountBalance[msg.sender] += amount;
    emit DepositSuccesfull(msg.sender, amount);
  }

  function withdraw(uint256 amount) public {
    if(accountBalance[msg.sender]<amount){
      revert insuficientFunds();
    }
    accountBalance[msg.sender] -= amount;

     if(accountBalance[msg.sender]==0) {
      delete accountBalance[msg.sender];
    }

    (bool success,)=msg.sender.call{value:amount}("");

    if(!success){
      revert withdrawFailed();
    }
    emit WithdrawSuccesfull(msg.sender, amount);

  }

  function checkBalance(address user) public view returns (uint256) {

    if(accountBalance[user]==0){
    revert addressNotFound();
  }
  return accountBalance[user];
  }


}
