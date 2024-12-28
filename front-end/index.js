window.addEventListener('load', async () => {
  if (typeof window.ethereum !== 'undefined') {
    // Connect to the user's Ethereum provider (MetaMask)
    const web3 = new Web3(window.ethereum);
    await window.ethereum.enable();
    const accounts = await web3.eth.getAccounts();
   
  
  // // Address of the deployed contract (use your actual contract address here)
  const contractAddress = "/**insert contract address here**/";
  const abi = [/**insert abi here**/];



    const contract = new web3.eth.Contract(abi, contractAddress);

  // Function to check the balance of the current account
  window.viewBalance = async () => {
    try {
        const balance = await contract.methods.viewBalance().call({ from: accounts[0] });
        document.getElementById('balance').innerText = `Your balance: ${web3.utils.fromWei(balance, 'ether')} ETH`;
    } catch (error) {
        console.error(error);
        alert('Error checking balance');
    }
};

    await viewBalance();
    // Function to deposit funds with lock-up period
    window.depositFunds = async () => {
      const depositAmount = document.getElementById('depositAmount').value;

      if (!depositAmount || depositAmount <= 0) {
        alert('Please enter a valid amount to deposit');
        return;
      }

      const depositAmountWei = web3.utils.toWei(depositAmount, 'ether');
      try {
        await contract.methods.deposit().send({
          from: accounts[0],
          value: depositAmountWei
        });
        alert(`${depositAmount} ETH
        
 successfully deposited`);
 await viewBalance(); // Update balance after sending
      } catch (error) {
        console.error(error);
        alert('Error depositing funds');
      }
    };

  


    window.sendFunds = async () => {
      const amount = document.getElementById('transferAmount').value;
      const recipientAddress = document.getElementById('recipientAddress').value;
  
      if (!amount || amount <= 0) {
          alert('Please enter a valid amount to transfer');
          return;
      }
  
      if (!recipientAddress || recipientAddress === '0x0') {
          alert('Please enter a valid recipient address');
          return;
      }
  
      const transferAmountWei = web3.utils.toWei(amount, 'ether');
  
      try {
          await contract.methods.send(transferAmountWei, recipientAddress).send({ from: accounts[0] });
          alert(`${amount} ETH successfully sent to ${recipientAddress}`);
          await viewBalance(); // Update balance after sending
      } catch (error) {
          console.error(error);
          alert('Error sending funds');
      }
  };
  
  


    // Function to withdraw funds from the contract
    window.withdrawFunds = async () => {
      const withdrawAmount = document.getElementById('withdrawAmount').value;

      if (!withdrawAmount || withdrawAmount <= 0) {
        alert('Please enter a valid amount to withdraw');
        return;
      }

      const withdrawAmountWei = web3.utils.toWei(withdrawAmount, 'ether');

      try {
        await contract.methods.withdraw(withdrawAmountWei).send({ from: accounts[0] });
        alert(`${withdrawAmount} ETH successfully withdrawn`);
                await viewBalance(); // Update balance after sending
      } catch (error) {
        console.error(error);
        alert('Error withdrawing funds');
      }
    };





  } else {
    alert('Please install MetaMask to use this dApp');
  }
});
