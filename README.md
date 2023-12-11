# Gecko-Fuzz
Automated On-Chain Fuzzing




# Technical Documentation
Based off LibAFL
Oracles: Fuzz,src,evm,oracles: More oracles can be written here
Producers: The producer is the component that is responsible for producing information used by oracles.


Token: THis is a vulnerable WXRP token contract which contains a function `redeem` allowing the reentancy attack. Additionally there is a `Bounty.sol` contract, to reward the fuzzer once it calls it.

Below is the intended solution that conducts flash loan reentancy attacks:
```
1. Borrow k XRP such that k > balance() / 10
2. depositXRP() with k XRP
3. redeem(k * 1e18) -- reentrancy contract --> getBounty()
4. Return k XRP
```

such that: 

```
// more than 10% of the difference been considered as an exploit detected
function status () external view returns (bool) {
    uint256 delta = WXRPV2.totalSupply() >= WXRPV2.balance() ? WXRPV2.totalSupply() - WXRPV2.balance() : WXRPV2.balance() - WXRPV2.totalSupply();
    uint256 tolerance = WXRPV2.balance() / 10;
    if (delta > tolerance) {
      return true;
    }
    return false;
}
```



Gecko Fuzz can exit will the full exploit to take the fund
