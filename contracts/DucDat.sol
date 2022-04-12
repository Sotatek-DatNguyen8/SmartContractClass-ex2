//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract DucDatToken is ERC20 {
    address public treasury;
    address public owner;
    
    constructor(address _owner) ERC20("DucDatToken", "DDT") {
        owner = _owner;
        treasury = _owner;
         _mint(msg.sender, 100 * 10**uint(decimals()));
    }

    // address[] backList;
    mapping(uint256 => address) public backList;
    uint256 public countOfBacklist = 0;
    function mint(address account, uint256 amount) public OnlyOwner {
        _mint(account, amount);
    }


    function burn(address account, uint256 amount) public OnlyOwner {
        _burn(account, amount);
    }

    function addToBackList(address _account) external OnlyOwner {
        console.log("address: ", _account);
        // backList.push(_account);
        backList[countOfBacklist] = _account;
        countOfBacklist++;
    }

    // function getBackList() public view virtual returns (address[] memory) {
    //     return backList;
    // }

    function removeFromBackList(address _account) external OnlyOwner {
        uint256 _index;
        for (uint256 i = 0; i < countOfBacklist; i++) {
            if (backList[i] == _account) {
                _index = i;
                break;
            } 
        }
        for (uint256 j = _index; j < countOfBacklist - 1; j++) {
            backList[j] = backList[j + 1];
        }
        // backList.pop();
        countOfBacklist--;
        delete backList[_index];
    }

    function transferInternal(
        address from,
        address to,
        uint256 value
    ) public OnlyUserNotInBackList {
        console.log("treasury sol: ", treasury);
        _transfer(from, to, (value) * 95 / 100);
        _transfer(from, treasury, (value * 5) / 100);
    }

    modifier OnlyOwner() {
        address _owner = msg.sender;
        require(_owner == owner, "Only owner can do it!");
        _;
    }

    modifier OnlyUserNotInBackList() {
        bool checkUserInBackList = false;
        address _user = msg.sender;
        for (uint256 i = 0; i < countOfBacklist; i++) {
            if (backList[i] == _user) {
                checkUserInBackList = true;
                break;
            }
        }
        require(!checkUserInBackList, "User must not exist in back list");
        _;
    }
}