Shelter Token
=============

Instructions
============

Deployment
----------
- First make sure you have NodeJS and the truffle library installed.
- Next head to migrations/1_deploy.js
- Enter the investor info in the arrays on lines 5&6
- Make sure to run `npm i` to install all dependancies
- Open `secrets.json` to enter in your mnemonic (for your wallet you will deploy with). Make sure this has gas funds
- Enter your infura ID (from www.infura.io)
- Enter your api key for etherscan or bscscan. This is to verify your contract when done. (Optional) 
- Run `truffle compile` to compile code without deploying to make sure there are no errors in code
- Run `truffle deploy --network kovan` to deploy to kovan Testnet.
- Run `truffle deploy --network ethMain` to deploy to mainnet
- Run `truffle run verify Shelter --network NETWORK_CHOSEN` to verify the Shelter contract on a given network's block explorer
- Run the same as above with with `Escrow` replacing `Shelter` to verify the Escrow contract

Toggling LP
-----------

IMPORTANT: When using Uniswap deposit V2 liquidity. NOT V3. By default it is V3, you have to click a little button that says "version 2" at the bottom of the pools page. I made it this way because v2 is simpler, and works with Pancakeswap on BSC, in case you decide to switch back. If you deposit V3 liquidity the LP tax is not going to work.  

When first launched the LP deposit tax is turned off. The "owner" of the contract: by default the deployer, will be able to toggle it on and off. you can change owners and toggle in the etherscan block explorer. There is a reason you must have it toggled off at first, because the LP deposit first swaps some of the token for ETH, and there must be liquidity for it to swap. So here's how you do that.

- Go to uniswap and find the pools section. Enter the deployed Shelter token's address and ETH as the pair. Deposit some liquidity, meaning a balance of both. This also sets the start price per SHELTOR.
- After this the token is ready to be toggled on so call the `setSwapAndLiquifyEnabled` function on etherscan with the true parameter to turn on LP deposits.
NOTE: txs will likely require more gas when LP is turned on

Info for frontend integration
=============================

approve
-------
Located in node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol  
This library function is inherited by Presale.sol which is inherited by ShelterNew.sol. So this funciton is included in the Shelter token. It is used to allow a contract (Escrow) to send tokens on a user's behaf.  
Must have the user call this function in the Shelter token contract before newBouty to avoid an error. parameters are the address to approve and the amount to approve.

newBounty
---------
Located in contracts/Escrow.sol  
This function creates a new bounty and pushes it to the bounties array.  
Parameters include an interger amount (in js must be a string or bn since its a 256b interger). This is the amount of Shelter Tokens to put up for the bounty.  
This function emits an event when done returning the index in the array (will need to listen for and publish this index in DB).

closeBounty
-----------
Located in contracts/Escrow.sol  
This function closes a bounty and sends a receiver the bounty.  
Parameters (in order) are the index of the bounty, and the receiver address to get the tokens. Caller of the function must be the sponsor who called newBounty for this index.  


abis
----
Abis are necessary for web3 integration and can be found in the build/contracts
