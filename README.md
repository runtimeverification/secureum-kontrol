## Secureum Workshop on Kontrol

This repository contains a project that will be used during a Secureum workshop on Kontrol. Contracts present in this repository are modified for educational purposes, please DO NOT use them in production.

## Documentation

Documentation and installation instructions for Kontrol can be found in [Kontrol Book](https://docs.runtimeverification.com/kontrol). Source code for Kontol is available in Kontrol [repository](https://github.com/runtimeverification/kontrol). 

## Workshop Instructions

### Day Three — Introduction to Kontrol

The first workshop for Kontrol is focused on basic usage of its commands in application to [WETH9](https://github.com/runtimeverification/secureum-kontrol/blob/master/src/tokens/WETH9.sol) contract.

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
The test being executed is as follows:
```solidity
    function test_approve(address from, address to, uint256 amount) public {
        vm.prank(from);
        asset.approve(to, amount);

        uint256 toAllowance = asset.allowance(from, to);
        assert(toAllowance == amount);
    }
```

### Help

If you need any assistance, please reach out to us in a dedicated [Secureum Discord channel](https://discord.com/channels/814328279468474419/1221389981516304425) or [RV Discord](https://discord.gg/CurfmXNtbN).