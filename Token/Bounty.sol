// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {IERC20} from "./interfaces/IERC20.sol";
import {IWXRP} from "./interfaces/IWXRP.sol";
import {IWXRPV2} from "./interfaces/IWXRPV2.sol";
import {IUniswapV2Pair} from "./interfaces/IUniswapV2Pair.sol";
import "./libraries/TransferHelper.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title The core logic for the WXRPV2 contract

contract Bounty is Ownable {
    IWXRPV2 public WXRPV2;
    bool public isHacked;
    address public WXRP;
    address public winner;

    constructor(address _WXRPV2, address _WXRP) {
        WXRP = _WXRP;
        WXRPV2 = IWXRPV2(_WXRPV2);
    }

    function status() external view returns (bool) {
        uint256 delta = WXRPV2.totalSupply() >= WXRPV2.balance()
            ? WXRPV2.totalSupply() - WXRPV2.balance()
            : WXRPV2.balance() - WXRPV2.totalSupply();
        uint256 tolerance = WXRPV2.balance() / 10;
        if (delta > tolerance) {
            return true;
        }
        return false;
    }

    function getBounty() public returns (bool) {
        uint256 delta = WXRPV2.totalSupply() >= WXRPV2.balance()
            ? WXRPV2.totalSupply() - WXRPV2.balance()
            : WXRPV2.balance() - WXRPV2.totalSupply();
        uint256 tolerance = WXRPV2.balance() / 10;
        if (delta > tolerance) {
            // reward the first finder
            isHacked = true;
            IERC20(WXRP).transfer(msg.sender, IERC20(WXRP).balanceOf(address((this))));
            winner = address(msg.sender);
        }
        return isHacked;
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    /// @notice pool owner can withdraw all the funds after 2022 Nov 20 12:00 PM
    /// @notice This function is not witnin the CTF attack surface, only for admin purposes
    function withdraw(address token) external onlyOwner {
        require(block.timestamp >= 1668974400, "pool not expired!");
        if (token == address(0)) {
            TransferHelper.safeTransferETH(msg.sender, address(this).balance);
        } else {
            TransferHelper.safeTransfer(token, msg.sender, IERC20(token).balanceOf(address(this)));
        }
    }
}
