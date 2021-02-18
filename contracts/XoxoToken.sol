pragma solidity 0.6.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./SmallXoxoToken.sol";

contract XoxoToken is ERC20("xoxo.finance", "XOXO"), Ownable {

    SmallXoxoToken public sxoxo;

    constructor(SmallXoxoToken _sxoxo) public {
        sxoxo = _sxoxo;
    }
    
    /// @notice overrides transfer function to add Xoxo features :
    /// 2% burn rate for every transfer
    /// Use the amount of burned token to mint sXoxo (so then, 3%)
    function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
        uint256 rateAmount = 3; // burn rate is 3%
    
        // Calculate the amount to burn
        // Example for 50 XOXO with the 3% rate : (50 x 2) / 100 = 1 XOXO to burn
        uint256 burnAmount = amount.mul(rateAmount).div(100); 

        // Calculate the amount to send (don't send the amount to burn)
        uint256 sendAmount = amount.sub(burnAmount); 

        // In case the burnAmount is invalid
        require(amount == sendAmount + burnAmount, "Burn value invalid");

        super._burn(sender, burnAmount);

        // Mint sXoxo
        sxoxo.mint(recipient,  burnAmount);
        
        super._transfer(sender, recipient, sendAmount);
        amount = sendAmount;
    }    

    /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (XoxoFarmContract).
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }
}