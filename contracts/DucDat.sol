//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
contract DucDatToken is ERC20 {
    using SafeMath for uint256;
    address public treasury;
    address public owner;

    
    constructor(address _owner) ERC20("DucDatToken", "DDT") {
        owner = _owner;
        treasury = _owner;
         _mint(msg.sender, 100 * 10**uint(decimals()));
    }

    // address[] backList;
    mapping(address => bool) public backList;
    function mint(address account, uint256 amount) public OnlyOwner {
        _mint(account, amount);
    }


    function burn(address account, uint256 amount) public OnlyOwner {
        _burn(account, amount);
    }

    function addToBackList(address _account) external OnlyOwner {
        console.log("address: ", _account);
        // backList.push(_account);
        backList[_account] = true;
    }

    function isInBackList(address _account) public view returns (bool){
        return backList[_account];
    }

    function removeFromBackList(address _account) external OnlyOwner {
        backList[_account] = false;
    }

    function transfer(
        address to,
        uint256 value
    ) public override OnlyUserNotInBackList returns (bool) {
        console.log("treasury sol: ", treasury);
        uint256 contribution = value.mul(95).div(100);
        uint256 _value = value.sub(contribution);
        _transfer(msg.sender, to, contribution);
        _transfer(msg.sender, treasury, _value);

        return true;
    }

    modifier OnlyOwner() {
        address _owner = msg.sender;
        require(_owner == owner, "Only owner can do it!");
        _;
    }

    modifier OnlyUserNotInBackList() {
        require(!backList[msg.sender], "User must not exist in back list");
        _;
    }
}