// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC4626} from "../src/ERC4626.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {ERC20Mock} from "openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

contract ERC4626Test is Test {
    ERC20Mock public asset;
    ERC4626 public vault;
    address public alice;
    address public bob;

    function setUp() public {
        alice = makeAddr("ALICE");
        bob = makeAddr("BOB");
        asset = new ERC20Mock();
        vault = new ERC4626(ERC20(address(asset)), "Vault", "VAULT");
    }

    function test_deposit_redeem(uint256 assets) public {
        assets = bound(assets, 1, type(uint128).max / 2);

        deal(address(asset), bob, assets);
        vm.startPrank(bob);
        asset.approve(address(vault), assets);
        vault.deposit(assets, bob);
        vm.stopPrank();

        deal(address(asset), alice, assets);
        vm.startPrank(alice);
        asset.approve(address(vault), assets);

        uint256 shares = vault.deposit(assets, alice);
        uint256 assetsAfter = vault.redeem(shares, alice, alice);
        assertTrue(assets >= assetsAfter);
    }

}
