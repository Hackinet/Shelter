//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "./Presale.sol";
import "./uniswap/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Sheltor is PresaleToken, Ownable{

    uint public constant ONE_HUNDRED_PERCENT = 10000;
    uint public constant CHARITY_TAX = 300;
    uint public constant LIQUIDITY_FEE = 300;
    address public constant charity = 0xb5bc62c665c13590188477dfD83F33631C1Da0ba;

    IUniswapV2Router02 uniRouter;

    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;


    constructor(address[] memory _investors, uint[] memory _amounts)PresaleToken("Sheltor Token", "SHELTOR", _investors, _amounts){
        uniRouter = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);     //Pacnackeswap for BSC
    }

        modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
    }

    /// @dev charity tax before any transfer
    function _beforeTokenTransfer(address from, address to, uint256 amount)internal override{
        if(from != address(0) && to != address(0)){
            _transfer(from, charity, _applyPercent(amount, CHARITY_TAX));
            _transfer(from, address(this), _applyPercent(amount, LIQUIDITY_FEE));
            swapAndLiquify(balanceOf(address(this)));
        }
    }

    /// @dev helper function to apply percents
    function _applyPercent(uint _num, uint _percent) private pure returns(uint256){
        return ((_num * _percent) / ONE_HUNDRED_PERCENT);
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        // split the contract balance into thirds
        uint256 halfOfLiquify = contractTokenBalance / 2;
        uint256 otherHalfOfLiquify = contractTokenBalance - halfOfLiquify;

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        // swap tokens for ETH
        swapTokensForEth(halfOfLiquify); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered

        // how much ETH did we just swap into?
        uint256 newBalance = address(this).balance - (initialBalance);

        // add liquidity to uniswap
        addLiquidity(otherHalfOfLiquify, newBalance);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniRouter.WETH();

        _approve(address(this), address(uniRouter), tokenAmount);

        // make the swap
        uniRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniRouter), tokenAmount);

        // add the liquidity
        uniRouter.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }


}