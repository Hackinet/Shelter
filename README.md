Sheltor Token
=============
Necessary functions for the fronted are described bellow

approve
-------
Located in node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol  
This library function is inherited by Presale.sol which is inherited by SheltorNew.sol. So this funciton is included in the Sheltor token. It is used to allow a contract (Escrow) to send tokens on a user's behaf.  
Must have the user call this function in the Sheltor token contract before newBouty to avoid an error. parameters are the address to approve and the amount to approve.

newBounty
---------
Located in contracts/Escrow.sol  
This function creates a new bounty and pushes it to the bounties array.  
Parameters include an interger amount (in js must be a string or bn since its a 256b interger). This is the amount of Sheltor Tokens to put up for the bounty.  
This function emits an event when done returning the index in the array (will need to listen for and publish this index in DB).

closeBounty
-----------
Located in contracts/Escrow.sol  
This function closes a bounty and sends a receiver the bounty.  
Parameters (in order) are the index of the bounty, and the receiver address to get the tokens. Caller of the function must be the sponsor who called newBounty for this index.  


abis
----
Abis are necessary for web3 integration and can be found in the build/contracts
