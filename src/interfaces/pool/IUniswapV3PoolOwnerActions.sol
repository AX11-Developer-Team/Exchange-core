// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @title Permissioned pool actions
/// @notice Contains pool methods that may only be called by the factory owner
/// Note these 2 functions can be called by factory owner via factory contract only
interface IUniswapV3PoolOwnerActions {
    /// @notice Set the denominator of the protocol's % share of the fees
    /// @param _DefaultProtocolFee pre-computed protocol fee amount
    function setFeeProtocol(uint8 _DefaultProtocolFee) external;

    function setFeeProtocolTo (address newProtocolFeeCollector) external;
}
