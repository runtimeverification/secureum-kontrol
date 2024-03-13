## Secureum Workshop on Kontrol

This repository contains a project that will be used during a Secureum workshop on Kontrol.

## Documentation

Documentation can be found in [Kontrol Book](https://docs.runtimeverification.com/kontrol).

## Usage

### Build

To build a project and include lemmas that are required to reason about keccak-related expressions (more on that later!), run
```shell
kontrol build --require lemmas/keccak-lemmas.k --module-import ERC4626Test:KECCAK-LEMMAS
```
This command will run `forge build` under the hood, and will, then, use the produced compilation artifacts to generate K definitions that can be verified.

### Prove

#### Verifying properties

To prove that the ERC4626's property "asset() MUST never revert" holds, run
```shell
kontrol prove --match-test test_prop_asset
```
The process should end successfully, indicating that this property is always true and, whoever is calling the function, `asset()` never reverts.
The test being executed is as follows:
```solidity
    // asset
    // "MUST NOT revert."
    function test_prop_asset(address caller) public {
        _notBuiltinAddress(caller);
        vm.prank(caller); vault.asset();
    }
```

To prove that `transfer()` function in WETH9 correctly adjusts user balances, run
```shell
kontrol prove --match-test WETH9Test.testTransfer
```

You might also try to prove the same property of ERC4626, however, if you execute
```shell
kontrol prove --match-test ERC4626Test.testTransfer
```
you will see that the test is failing if `address from` is `0`, as checked in one of the `require` statements. Running the same command with `--hevm` should make the test pass, as, in this case, a less strict `hevm` success predicate will be used instead of the default `foundry` one.

#### Proving equivalence

Kontrol, and FV in general, can be used to assert equivalence between different implementations of smart contract functions. To prove that a highly optimized implementation of `mulWad` funciton in Solady is equivalent to a more readable Solidity version, run
```shell
kontrol build --require lemmas/eq-lemmas.k --module-import EquivalenceTest:EQ-LEMMAS
```
to build a project with useful lemmas. Then, run
```shell
kontrol prove --match-test testMulWad
```

### Help

If you need any assistance, please reach out to us in a dedicated [Secureum Discord channel](https://discord.com/channels/814328279468474419/1221389981516304425) or [RV Discord](https://discord.gg/CurfmXNtbN).