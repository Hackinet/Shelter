//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PresaleToken is ERC20{

    uint lockEnd;
    uint presaleCount = 0;
    address[] investors;
    mapping (address => uint) public presaleOwedPerPeriod;
    uint private constant ONE_WEEK = 604800;

    constructor(string memory _name, string memory _symbol, address[] memory _investors, uint[] memory _amounts)ERC20(_name, _symbol){
        require(_investors.length == _amounts.length, "The arrays size must match");
        uint subFromTotal = 0;
        investors = _investors;
        for(uint i = 0; i < _investors.length; i++){
            presaleOwedPerPeriod[_investors[i]] = _amounts[i]/10;
            subFromTotal += _amounts[i];
        }
        lockEnd = block.timestamp + ONE_WEEK;
        _mint(msg.sender, 100000000000 ether);
    }
}