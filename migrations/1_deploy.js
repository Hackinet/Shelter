const Sheltor = artifacts.require("Sheltor");
const Escrow = artifacts.require("Escrow");

//NOTE: These arrays must be the same length or deployment will fail
const investors = []            //Enter investor addresses array here
const investorsAmounts = []     //Enter the amounts each investor is owed TOTAL here. matching the index in the first array

module.exports = async(deployer)=>{

    //Deploy sheltor token with arguments
    await deployer.deploy(Sheltor,investors,investorsAmounts);
    const sheltor = Sheltor.deployed();

    //Deploy escrow contract with sheltor's address as a parameter
    await deployer.deploy(Escrow, sheltor.address);
}