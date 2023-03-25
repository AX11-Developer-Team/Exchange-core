// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IUniswapV3PoolDeployer} from "./interfaces/IUniswapV3PoolDeployer.sol";

import {UniswapV3Pool} from "./UniswapV3Pool.sol";

contract UniswapV3PoolDeployer is IUniswapV3PoolDeployer {
    struct Parameters {
        address factory;
        address ProtocolFeeCollector;
        address token0;
        address token1;
        uint24 fee;
        int24 tickSpacing;
        uint8 protocolFee;
    }

    /// @inheritdoc IUniswapV3PoolDeployer
    Parameters public override parameters;

    /// @dev Deploys a pool with the given parameters by transiently setting the parameters storage slot and then
    /// clearing it after deploying the pool.
    /// @param factory The contract address of the Uniswap V3 factory
    /// @param ProtocolFeeCollector The address that stores all the protocolFees
    /// @param token0 The first token of the pool by address sort order
    /// @param token1 The second token of the pool by address sort order
    /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
    /// @param tickSpacing The spacing between usable ticks
    function deploy(
        address factory,
        address ProtocolFeeCollector,
        address token0,
        address token1,
        uint24 fee,
        int24 tickSpacing,
        uint8 protocolFee
    ) internal returns (address pool) {
        parameters = Parameters({
            factory: factory,
            ProtocolFeeCollector: ProtocolFeeCollector,
            token0: token0,
            token1: token1,
            fee: fee,
            tickSpacing: tickSpacing,
            protocolFee: protocolFee
        });
        pool = address(
            new UniswapV3Pool{
                salt: keccak256(abi.encode(token0, token1, fee))
            }()
        );
        delete parameters;
    }
}
