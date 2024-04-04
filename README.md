## Secureum Workshop on Kontrol

This repository contains a project that will be used during a Secureum workshop on Kontrol. Contracts present in this repository are modified for educational purposes, please DO NOT use them in production.

## Documentation

Documentation and installation instructions for Kontrol can be found in [Kontrol Book](https://docs.runtimeverification.com/kontrol). Source code for Kontol is available in Kontrol [repository](https://github.com/runtimeverification/kontrol). 

## Workshop Instructions

### Day Three — Introduction to Kontrol

The first workshop for Kontrol is focused on basic usage of its commands in application to [WETH9](https://github.com/runtimeverification/secureum-kontrol/blob/master/src/tokens/WETH9.sol) contract and the [tests]([url](https://github.com/runtimeverification/secureum-kontrol/blob/master/test/WETH9.t.sol)) we have defined for it.

### Build

To clone and build this project, run 

```shell
git clone https://github.com/runtimeverification/secureum-kontrol.git && cd secureum-kontrol
```
followed by 
```shell
kontrol build
```
This command will run `forge build` under the hood, and will, then, use the produced compilation artifacts to generate K definitions that can be verified. You can inspect the `out/` folder to view the artifacts produced by `kontrol build` and make sure that it executed successfully.

### Prove

To prove that WETH9 `approve()` function changes `allowance` correctly, you can run the following command:
```shell
kontrol prove --match-test 'WETH9Test.test_approve(address,address,uint256)'
```
The process should end successfully, indicating that this property is always true and, whatever the values of `from`, `to`, and `amount` are, `approve()` behaves correctly.
The [test]([url](https://github.com/runtimeverification/secureum-kontrol/blob/master/test/WETH9.t.sol)) being executed is as follows:
```solidity
    function test_approve(address from, address to, uint256 amount) public {
        vm.prank(from);
        asset.approve(to, amount);

        uint256 toAllowance = asset.allowance(from, to);
        assert(toAllowance == amount);
    }
```
### Day Four — Advanced Symbolic Testing with Kontrol

The second workshop for Kontrol will cover several aspects, including [ERC4626](https://github.com/runtimeverification/secureum-kontrol/blob/master/test/ERC4626.t.sol) tests, addressing verification challenges such as loops and dynamically-sized Solidity types, and proving equivalence between Solidity and low-level gas optimized implementations for [Solady](https://github.com/runtimeverification/secureum-kontrol/blob/master/test/Equivalence.t.sol).

### Proving properties 

In the first part of the workshop, the following commands would help build the project and run two tests for the ERC4626 implementation we are using:
```shell
kontrol build
kontrol prove --match-test test_totalAssets_doesNotRevert --match-test test_totalAssets_revertsWhenPaused -j2
```

The first test, checking if `test_totalAssets_doesNotRevert` never reverts, as requested by the EIP
```solidity
    function test_totalAssets_doesNotRevert(address caller) public {
        _notBuiltinAddress(caller);
        vm.prank(caller); vault.totalAssets();
    }
```
will revert, since the implementation of the ERC4626 vault we are using here (for illustration purposes!) reverts if the contract has been paused.

### Proving equivalence

Kontrol, and FV in general, can be used to assert equivalence between different implementations of smart contract functions. To prove that a highly optimized implementation of `mulWad` funciton in Solady is equivalent to a more readable Solidity version, run
```shell
kontrol build --require lemmas/eq-lemmas.k --module-import EquivalenceTest:EQ-LEMMAS
```
to build a project with lemmas that, as discussed in the workshop, are needed for the following test to succeed:
```solidity
    function test_mulWad(uint256 x, uint256 y) public {
        if (y == 0 || x <= type(uint256).max / y) {
            uint256 zSpec = (x * y) / WAD;
            uint256 zImpl = mulWad(x, y);
            assert(zImpl == zSpec);
        } else {
            vm.expectRevert();
            this.mulWad(x, y);
        }
    }
```
Then, run
```shell
kontrol prove --match-test testMulWad --smt-solver 10000
```

### Help

If you need any assistance, please reach out to us in a dedicated [Secureum Discord channel](https://discord.com/channels/814328279468474419/1221389981516304425) or [RV Discord](https://discord.gg/CurfmXNtbN).
