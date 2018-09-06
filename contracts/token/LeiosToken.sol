pragma solidity ^0.4.24;

import "./ERC20Burnable.sol";

/**
 * @title AirSaveTravelToken
 */
contract LeiosToken is ERC20Burnable {
    string public constant name = "Leios token";
    string public constant symbol = "LEIOS";
    uint8 public constant decimals = 18;

    uint256 public constant INITIAL_SUPPLY = 125000000 * 1 ether; // Need to change

    /**
     * @dev Constructor
     */
    constructor() public {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}