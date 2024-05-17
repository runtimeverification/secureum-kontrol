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

    /// @notice To prevent assets overflow in functions such as `convertToShares`
    /// When converting from assets to shares, the amount of assets is multipled by the totalSupply.
    /// Hence, to avoid integer overflow, we need to make sure assets < MAX_UINT256 / totalSupply.
    /// @dev Limit for overflow is reference from Solmate EIP-4626 and OZ ERC4626.sol.
    modifier assetsOverflowRestriction(uint256 assets) {
        if (vault.totalSupply() > 0) { 
            vm.assume(assets < type(uint256).max / vault.totalSupply()); 
        }
        _;
    }

    /// @notice To prevent shares overflow in functions such as `convertToAssets`
    /// When converting from shares to assets, the amount of shares is multipled by the totalAssets + 1 
    /// (OZ implementation). Hence, to avoid integer overflow, we need to make sure 
    /// shares < MAX_UINT256 / (totalAssets + 1).
    /// @dev Limit for overflow is reference from OZ ERC4626.sol 
    /// NOTE: Limit for overflow from Solmate EIP-4626 is shares < MAX_UINT256 / totalAssets instead
    modifier sharesOverflowRestriction(uint256 shares) {
        if (cut4626.totalSupply() > 0) { 
            vm.assume(shares < type(uint256).max / (cut4626.totalAssets() + 1));
        }
        _;
    }

    function _notBuiltinAddress(address addr) internal view {
        vm.assume(addr != address(this));
        vm.assume(addr != address(vm));
        vm.assume(addr != address(asset));
        vm.assume(addr != address(vault));
        vm.assume(addr != address(0x0));
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

    function test_assume_noOverflow_freshVars() public {
        uint256 x = kevm.freshUInt(32);
        uint256 y = kevm.freshUInt(32);
        vm.assume(x <= x + y);
        assert(true);
    }

    function test_convertToShares_doesNotRevert(uint256 assets) public
    {
        vault.convertToShares(assets);
    }

    function test_convertToAssets_doesNotRevert(uint256 shares) public {
        vault.convertToAssets(shares);
    }  
}