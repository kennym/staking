// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

import "./MintedCrowdsale.sol";

contract gAsuCrowdSale is MintedCrowdsale {
    constructor (uint256 rate, address payable wallet, IERC20 token)
        Crowdsale(rate,wallet,token)
        public
    {
        
    }
    
}