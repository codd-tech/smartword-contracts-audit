// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./constants.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

/**
 * @title SmartWorld Global Token
 * @author https://codd.tech
 * @notice Smart contract implements token for SmartWorld Global
 */
contract SWGT is ERC20, ERC20Burnable {
    constructor() ERC20("SmartWorld Global Token", "SWGT") {
        _mint(msg.sender, TOTAL_SWGT_SUPPLY * 10 ** decimals());
    }

    function decimals() public view virtual override returns (uint8) {
        return 8;
    }
}
