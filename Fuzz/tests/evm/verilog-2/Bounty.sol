// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC20} from "./interfaces/IERC20.sol";
import {IWXRP} from "./interfaces/IWXRP.sol";
import {IWXRPV2} from "./interfaces/IWXRPV2.sol";
import {IUniswapV2Pair} from "./interfaces/IUniswapV2Pair.sol";
import "./libraries/TransferHelper.sol";
import "../../../solidity_utils/lib.sol";

/// @title The core logic for the WXRPV2 contract

contract Bounty {
    IWXRPV2 public WXRPV2;
    bool public isHacked;
    address public WXRP;
    address public winner;

    constructor() {
        WXRP = address(0x8);
        WXRPV2 = IWXRPV2(address(0xDA3AF9c51F6953988a46C21d43A5152AFC7f389d));
    }

    function getBounty() public payable returns (bool) {
        //        if (WXRPV2.totalSupply() != WXRPV2.balance()) {
        //            bug();
        //        }
        uint256 delta = WXRPV2.totalSupply() >= WXRPV2.balance()
            ? WXRPV2.totalSupply() - WXRPV2.balance()
            : WXRPV2.balance() - WXRPV2.totalSupply();

        uint256 tolerance = WXRPV2.balance() / 10;
        if (delta > tolerance) {
            bug();

            // reward the first finder
            isHacked = true;
            //            IERC20(WXRP).transfer(msg.sender, IERC20(WXRP).balanceOf(address((this))));
            winner = address(msg.sender);
        }

        return isHacked;
    }
}
