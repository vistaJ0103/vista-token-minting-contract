// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Mytoken1 is Initializable, ERC20Upgradeable, OwnableUpgradeable {
    mapping(address => bool) public blacklist;

    event AddedToBlacklist(address indexed account);
    event RemovedFromBlacklist(address indexed account);

    function initialize() public initializer {
        __ERC20_init("Vista Test Token", "VTT");
        __Ownable_init(msg.sender);
        _mint(msg.sender, 10000 * (10 ** uint256(decimals())));
    }

    function mint(uint256 _amount) external {
        _mint(msg.sender, _amount * (10 ** uint256(decimals())));
    }

    function burn(uint256 _amount) external {
        _burn(msg.sender, _amount);
    }

    function addToBlacklist(address account) external onlyOwner {
        require(!blacklist[account], "User is already on the blacklist.");
        blacklist[account] = true;
        emit AddedToBlacklist(account);
    }

    function removeFromBlacklist(address account) external onlyOwner {
        require(blacklist[account], "User is not on the blacklist.");
        delete blacklist[account];
        emit RemovedFromBlacklist(account);
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(!blacklist[msg.sender], "Sending address is blacklisted.");
        require(!blacklist[recipient], "Receiving address is blacklisted");
        return super.transfer(recipient, amount);
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        _transferOwnership(newOwner);
    }
}
