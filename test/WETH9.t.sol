// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";
import "../src/tokens/WETH9.sol";

contract WETH9Test is Test, KontrolCheats {
    WETH9 public asset;
    address public alice;
    address public bob;

    function setUp() public {
        asset = new WETH9();

        alice = makeAddr("Alice");
        bob = makeAddr("Bob");
    }

    function test_approve_AliceToBob(uint256 amount) public {
        // Foundry cheatcode changing `msg.sender` to specified address
        vm.prank(alice);
        // `alice` approving `amount` WETH to `bob`
        asset.approve(bob, amount);

        // reading updated `bob` allowance to spend `alice` tokens
        uint256 bobAllowance = asset.allowance(alice, bob);
        // asserting that it was updated to `amount`
        assert(bobAllowance == amount);
    }

    function test_approve(address from, address to, uint256 amount) public {
        vm.prank(from);
        asset.approve(to, amount);

        uint256 toAllowance = asset.allowance(from, to);
        assert(toAllowance == amount);
    }

    function test_deposit(address from) public payable {
        _notBuiltinAddress(from);

        vm.prank(from);
        asset.deposit{value: msg.value}();
    }

    function _notBuiltinAddress(address addr) internal view {
        vm.assume(addr != address(this));
        vm.assume(addr != address(vm));
        vm.assume(addr != address(asset));
    }

    /*
    function test_withdraw(address from, uint256 amount) public payable {
        _notBuiltinAddress(from);

        vm.assume(from > address(9));
        vm.deal(address(asset), amount);

        kevm.symbolicStorage(address(asset));

        vm.prank(from);
        asset.withdraw(amount);
    }
    */
}
