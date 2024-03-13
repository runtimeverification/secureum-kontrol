// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC4626} from "../src/tokens/ERC4626.sol";
import {ERC20} from "../src/tokens/ERC20.sol";
import {ERC20Mock} from "../src/mocks/ERC20Mock.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

contract ERC4626Test is Test, KontrolCheats {
    ERC20 public asset;
    ERC4626 public vault;
    address public alice;
    address public bob;

    function _notBuiltinAddress(address addr) internal view {
        vm.assume(addr != address(this));
        vm.assume(addr != address(vm));
        vm.assume(addr != address(asset));
        vm.assume(addr != address(vault));
    }

    function setUp() public {
        asset = new ERC20Mock();
        vault = new ERC4626(ERC20(address(asset)), "Vault", "VAULT");

        kevm.symbolicStorage(address(vault));
    }

    // totalAssets MUST NOT revert
    function test_totalAssets_doesNotRevert(address caller) public {
        _notBuiltinAddress(caller);
        vm.prank(caller); vault.totalAssets();
    }

    // totalAssets MUST revert when paused
    function test_totalAssets_revertsWhenPaused(address caller) public {
        _notBuiltinAddress(caller);

        vm.assume(!vault.paused());
        vault.pause();

        vm.startPrank(caller); 

        vm.expectRevert();
        vault.totalAssets();
    }

    function test_approve_emitsEvent(address from, address to, uint256 amount) public {
        _notBuiltinAddress(from);
        _notBuiltinAddress(to);

        vm.expectEmit(true, true, false, true);
        emit ERC20.Approval(from, to, amount);

        vm.prank(from);
        vault.approve(to, amount);
    }

    function test_assume_noOverflow(uint x, uint y) public {
        vm.assume(x <= x + y);
        assert(true);
    }
}