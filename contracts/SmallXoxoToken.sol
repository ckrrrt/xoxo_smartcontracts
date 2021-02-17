pragma solidity ^0.6.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SmallXoxoToken is ERC20("Small Xoxo", "sXOXO"), Ownable {
    using SafeMath for uint256;

    // Address in charge of the sXoxo Token. Earn 1% when it's minted.
    // Allows to remunerate a team member (community manager for example)
    address res; 

    constructor(address _res) public {
        res = _res;
    }

    // mints new sXoxo tokens, can only be called by Xoxo Token (the owner)
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
        transferRes(_amount);
    }

    function setRes(address _res) public {
        require(msg.sender == res, "sXoxo: setRes invalid signer");
        res = _res;
    }

    function transferRes(uint256 _amount) private {
        _mint(res, _amount.div(100));
    }
}