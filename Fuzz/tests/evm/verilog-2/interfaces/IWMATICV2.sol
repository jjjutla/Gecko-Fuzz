pragma solidity ^0.8.15;

interface IWXRPV2 {
    function totalSupply() external view returns (uint256);

    function balance() external view returns (uint256);
}
