// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./Claimable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/**
 * @dev: deprecated legacy token
 */
contract LegacyToken is ERC20, ERC20Burnable, Claimable {
    constructor() ERC20("Legacy Token", "LGS") {}

    function decimals() public view virtual override returns (uint8) {
        return 8;
    }

    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param value The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to, uint256 value) public onlyOwner returns (bool) {
        require(value > 0);
        _mint(to, value);
        return true;
    }
}
