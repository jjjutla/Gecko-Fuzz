pragma solidity 0.8.10;

interface IWXRPV2 {
    function totalSupply() external view returns (uint256);

    function balance() external view returns (uint256);
}
