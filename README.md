# Gecko-Fuzz
A Gecko is a small, mostly carnivorous lizard known for feeding off bugs. Similarly, Gecko Fuzz is a novel autonomous on-chain smart contract auditing tool combining fuzzing and formal verification to find bugs in your code.
<img width="1394" alt="Screenshot 2023-12-12 at 00 37 32" src="https://github.com/jjjutla/Gecko-Fuzz/assets/22000925/4655d023-4c55-46a4-8024-3f2fe9cf9a72">

### Links:
- Technical Documentation: https://drive.google.com/file/d/1MvZgZ2uVl6PklBOI5uvymGcMyeZGNcdy/view?usp=sharing
- Slides: https://drive.google.com/file/d/16F0SmAfB1t2qYJqaX60Xid7jAVwp4AQI/view?usp=sharing
- Video 1: https://www.youtube.com/watch?v=rrVjMwuIwxM
- Video 2: https://youtu.be/DRwBQV5938M


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
