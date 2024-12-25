// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MemeCoin is ERC20 {

    constructor() ERC20("GameOn", "GO") {
        _mint(address(this), 100000000000 * 10**18); // Mint initial tokens to the contract
    }

    // Function to mint tokens to any address
    function mintTokens(address to, uint256 amount) external {
        require(to != address(0), "Invalid address");
        _mint(to, amount); // Mint the specified amount to the given address
    }

    // Function to claim tokens (no restrictions on the number of claims)
    function claimInitialTokens() external {
        uint256 initialAmount = 1000 * 10**18; // 1000 tokens
        _transfer(address(this), msg.sender, initialAmount);
    }
}
