// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MultiVault} from "../src/tokens/MultiVault.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

contract MultiVaultTest is Test, KontrolCheats {
    MultiVault public multiVault;

    struct Vault {
        address asset;
        uint256 totalSupply;
        bytes vaultData;
    }

    function _notBuiltinAddress(address addr) internal view {
        vm.assume(addr != address(this));
        vm.assume(addr != address(vm));
        vm.assume(addr != address(multiVault));
    }

    function setUp() public {
        multiVault = new MultiVault();
    }

    /// @custom:kontrol-bytes-length-equals vaultData: 256,
    function test_create_vault(address asset, uint256 totalSupply, bytes calldata vaultData) public {
        multiVault.create(asset, totalSupply, vaultData);
    }

    /// @custom:kontrol-array-length-equals vaults: 4,
    /// @custom:kontrol-bytes-length-equals vaultData: 256,
    function test_create_loop(Vault[] calldata vaults, uint length) public {
        // WARN: missing check on `vaults.length` and `length`
        // WARN: Unbounded `for` loop is an anti-pattern 
        for (uint i = 0; i < length; i++) {
            multiVault.create(vaults[i].asset, vaults[i].totalSupply, vaults[i].vaultData);
        }
    }
}