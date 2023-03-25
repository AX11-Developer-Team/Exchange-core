// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IUniswapV3PoolDeployer} from '../interfaces/IUniswapV3PoolDeployer.sol';

import {MockTimeUniswapV3Pool} from './MockTimeUniswapV3Pool.sol';

contract MockTimeUniswapV3PoolDeployer is IUniswapV3PoolDeployer {
    struct Parameters {
        address factory;
        address ProtocolFeeCollector;
        address token0;
        address token1;
        uint24 fee;
        int24 tickSpacing;
        uint8 protocolFee;
    }

    Parameters public override parameters;

    event PoolDeployed(address pool);

    function deploy(
        address factory,
        address ProtocolFeeCollector,
        address token0,
        address token1,
        uint24 fee,
        int24 tickSpacing,
        uint8 protocolFee
    ) external returns (address pool) {
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
            new MockTimeUniswapV3Pool{salt: keccak256(abi.encodePacked(token0, token1, fee, tickSpacing))}()
        );
        emit PoolDeployed(pool);
        delete parameters;
    }
}
