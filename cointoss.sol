// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CoinTossGame {
    IERC20 public memeToken;
    address public owner;

    mapping(address => uint256) public balances;

    uint256 public constant BET_AMOUNT = 1 * 10**18;  // 1 TMT
    uint256 public constant WIN_REWARD = 2 * 10**18;  // 2 TMT
    uint256 public constant LOSE_PENALTY = 0;  // No penalty on loss

    event GamePlayed(address indexed player, string playerChoice, string computerChoice, bool isWin, uint256 newBalance);
    event GameEnded(address indexed player, uint256 finalBalance);

    constructor(address _memeToken) {
        memeToken = IERC20(_memeToken);
        owner = msg.sender;
    }

    function startGame() external {
        // No entry fee needed for starting the game
        balances[msg.sender] = memeToken.balanceOf(msg.sender);
        emit GamePlayed(msg.sender, "", "", false, balances[msg.sender]);
    }

    function playGame(string memory playerChoice) external {
        require(memeToken.balanceOf(msg.sender) >= BET_AMOUNT, "Insufficient balance to play");

        // Deduct the BET_AMOUNT for the game
        memeToken.transferFrom(msg.sender, address(this), BET_AMOUNT);

        // Coin toss: computer choice is random (heads or tails)
        string memory computerChoice = randomChoice();

        bool isWin = (keccak256(abi.encodePacked(playerChoice)) == keccak256(abi.encodePacked(computerChoice)));

        // Adjust balances based on the outcome
        if (isWin) {
            memeToken.transfer(msg.sender, WIN_REWARD);
        }

        balances[msg.sender] = memeToken.balanceOf(msg.sender);

        emit GamePlayed(msg.sender, playerChoice, computerChoice, isWin, balances[msg.sender]);
    }

    function randomChoice() internal view returns (string memory) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 2;
        return random == 0 ? "heads" : "tails";
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function endGame() external {
        emit GameEnded(msg.sender, balances[msg.sender]);
        delete balances[msg.sender];
    }
}
