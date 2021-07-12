// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20Capped.sol";
import "./ERC20Burnable.sol";
import "./Ownable.sol";
import "../depositContract/IdepositContract.sol";

contract gAsuncion is ERC20Capped , Ownable {
    
    bytes  public _pubkey;
    bytes  public _withdrawal_credentials;
    bytes  public _signature;
    bytes32 public _deposit_data_root;
    IDepositContract _depositContract = IDepositContract(0xff50ed3d0ec03aC01D4C79aAd74928BFF48a7b2b);

    receive() external payable{}
    fallback()external payable{}

    function balance() public view returns(uint256){
        return address(this).balance;
    }
    
    function mint(address _account, uint256 _amount) public onlyOwner returns(bool){
        _mint(_account,_amount);
        return true;
    }
    
    function deposit() external payable onlyOwner {
        require(address(this).balance == 32e18 , "Aun no se tienen los fondos necesarios : 32 ETH");
        _depositContract.deposit{value:32e18}(_pubkey,_withdrawal_credentials,_signature,_deposit_data_root);
    }
    
    constructor(
            string memory name_,
            string memory symbol_,
            uint256 cap_,
            bytes memory pubkey_,
            bytes memory withdrawal_credentials_,
            bytes memory signature_,
            bytes32 deposit_data_root_
            
        ) 
        ERC20Capped(cap_)
        ERC20(name_,symbol_)
        Ownable()
    {
        _pubkey = pubkey_;
        _withdrawal_credentials = withdrawal_credentials_;
        _signature = signature_;
        _deposit_data_root = deposit_data_root_;
    }
    
}