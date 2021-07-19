const Shelter = artifacts.require("Shelter");
const Escrow = artifacts.require("Escrow");

//NOTE: These arrays must be the same length or deployment will fail
const investors = []            //Enter investor addresses array here
const investorsAmounts = []     //Enter the amounts each investor is owed TOTAL here. matching the index in the first array

module.exports = async(deployer)=>{

    //Deploy shelter token with arguments
    await deployer.deploy(Shelter,investors,investorsAmounts);
    const shelter = await Shelter.deployed();

    //Deploy escrow contract with shelter's address as a parameter
    await deployer.deploy(Escrow, shelter.address);
}