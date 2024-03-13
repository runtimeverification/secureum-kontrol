import {Test, console} from "forge-std/Test.sol";

contract EquivalenceTest is Test {
    uint256 internal constant WAD = 1e18; // The scalar of ETH and most ERC20s.

    /// @dev Equivalent to `(x * y) / WAD` rounded down.
    function mulWad(uint x, uint y) public returns (uint256 z) {
        assembly {
            // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
            if mul(y, gt(x, div(not(0), y))) {
                mstore(0x00, 0xbac65e5b) // `MulWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := div(mul(x, y), WAD)
        }
    }

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
}