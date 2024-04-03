// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.1;

import {ERC20} from "./ERC20.sol";
import {SafeTransferLib} from "../utils/SafeTransferLib.sol";
import {FixedPointMathLib} from "../utils/FixedPointMathLib.sol";

/// @notice Prototype of ERC4626 MultiVault extension
/// @author Modified from MultiVault (https://github.com/z0r0z/MultiVault/blob/main/src/MultiVault.sol)
contract MultiVault {
    using SafeTransferLib for ERC20;
    using FixedPointMathLib for uint256;

    /*///////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Create(address indexed asset, uint256 id);

    /*///////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice Vault id tracking
    uint256 public id;

    /// @notice Multiple vault underlying assets
    mapping(uint256 => Vault) public vaults;

    struct Vault {
        address asset;
        uint256 totalSupply;
        bytes vaultData;
    }

    /*///////////////////////////////////////////////////////////////
                            MULTIVAULT LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Create new Vault
    /// @param asset new underlying token for vaultId
    function create(address asset, uint256 totalSupply, bytes calldata data) public returns (bool) {
        vaults[id].asset = asset;
        vaults[id].totalSupply = totalSupply;
        vaults[id].vaultData = data;
        id += 1;

        emit Create(asset, id);

        return true;
    }

    // the rest of the logic is omitted
}