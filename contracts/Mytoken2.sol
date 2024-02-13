// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
contract Mytoken2 is Initializable, ERC20Upgradeable, OwnableUpgradeable {
    // using AddressUpgradeable for address;
    uint256 public mTotalSupply;
    mapping(address => bool) public blackLists;
    mapping(address => bool) private operators;

    // constructor() {
    //     _disableInitializers();
    // }

    modifier onlyOperator() {
        require(isOperator(msg.sender) == true, "IDO: caller is not operator");
        _;
    }

    // /**
    //  * @notice Nakapad owner creates nakapad token
    //  * @param _name: Name of nakapad token
    //  * @param _symbol: Symbol of nakapad token
    //  */
    function initialize(uint256 _totalSupply) public initializer {
        __ERC20_init("Vista Test Token", "VTT");
        __Ownable_init(msg.sender);
        mTotalSupply = _totalSupply;
    }

    function mint(uint256 _amount) external {
        require(
            totalSupply() + _amount <= mTotalSupply,
            "Overflow limit amount, cannot mint"
        );
        _mint(msg.sender, _amount);
    }

    function burn(uint256 _amount) external {
        _burn(msg.sender, _amount);
    }

    // White-list or blacklist multiple routers, can only be called by the operator.
    function setBlackList(
        address[] calldata _routers,
        bool[] calldata allows
    ) external onlyOwner {
        require(_routers.length == allows.length, "mistmatch params");
        for (uint256 i = 0; i < _routers.length; ++i) {
            blackLists[_routers[i]] = allows[i];
        }
    }

    function transfer(address from, address to, uint256 amount) internal {
        require(!blackLists[to], "Cannot transfer to un-allowed contract");
        super._transfer(from, to, amount);
    }

    // /**
    //  * @notice Check if user is an operator
    //  * @param addr: Address of user's account
    //  * @return isOperator: Return true if user is an operator, false otherwise
    //  */
    function isOperator(address addr) public view returns (bool) {
        return operators[addr];
    }

    // /**
    //  * @notice IDOFactory owner sets or removes a operator
    //  * @param operator: Address of operator
    //  * @param canOperate: possible of operator
    //  */
    function setOperator(address operator, bool canOperate) external onlyOwner {
        operators[operator] = canOperate;
    }
}
