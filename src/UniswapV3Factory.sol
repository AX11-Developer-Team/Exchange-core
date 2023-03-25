// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IUniswapV3Factory} from "./interfaces/IUniswapV3Factory.sol";
import {UniswapV3PoolDeployer} from "./UniswapV3PoolDeployer.sol";
import {NoDelegateCall} from "./NoDelegateCall.sol";
import {UniswapV3Pool} from "./UniswapV3Pool.sol";

/// @title Canonical Uniswap V3 factory
/// @notice Deploys Uniswap V3 pools and manages ownership and control over pool protocol fees
/// @notice decisions are made to find the sweet spot between 1.lower gas cost 2.downsize the contract
/// @notice uint/int256 requires more storage slots than uint8 to uint128, but it helps reduce contract size and gas in some cases.
/// @notice AX11 devs customize the contract to make protocol fee adjustment and feeTo adjustment for deployed and incoming pools.
contract UniswapV3Factory is
    IUniswapV3Factory,
    UniswapV3PoolDeployer,
    NoDelegateCall
{
    address private constant owner = 0x2Ed953Ef5A351d1ab0B814d48E725D1D1d143dc7; // address of FactoryManager.sol

    /// @inheritdoc IUniswapV3Factory
    mapping(uint256 => int256) public override feeAmountTickSpacing; //change to 256 to save gas
    /// @inheritdoc IUniswapV3Factory
    mapping(address => mapping(address => mapping(uint256 => address)))
        public
        override getPool;

    /// @inheritdoc IUniswapV3Factory
    address public override protocolFeeTo;

    /// @inheritdoc IUniswapV3Factory
    uint8 public override protocolFee;

    /// @inheritdoc IUniswapV3Factory
    address[] public override allPairs;

    constructor() {
        protocolFeeTo = address(0);
       
        protocolFee = 0;

        feeAmountTickSpacing[100] = 2; //0.01%

        feeAmountTickSpacing[500] = 10; // 0.05%

        feeAmountTickSpacing[1000] = 20; //0.1%

        feeAmountTickSpacing[2500] = 50; // 0.25%

        feeAmountTickSpacing[5000] = 100; // 0.5%

        feeAmountTickSpacing[7500] = 150; // 0.75%

        feeAmountTickSpacing[10000] = 200; // 1%

        feeAmountTickSpacing[15000] = 300; // 1.5%
    }

    /// @inheritdoc IUniswapV3Factory
    function createPool(
        address tokenA,
        address tokenB,
        uint256 fee
    ) external override noDelegateCall returns (address pool) {
        require(tokenA != tokenB);
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        require(token0 != address(0) && feeAmountTickSpacing[fee] != 0); // make sure users do not create custom fee outside pre-defined feeAmountTickSpacing
        require(getPool[token0][token1][fee] == address(0)); // make sure the pool never existed before

        pool = deploy(
            address(this),
            protocolFeeTo,
            token0,
            token1,
            uint24(fee),
            int24(feeAmountTickSpacing[fee]),
            protocolFee
        );

        getPool[token0][token1][fee] = pool;
        // populate mapping in the reverse direction, deliberate choice to avoid the cost of comparing addresses
        getPool[token1][token0][fee] = pool;
        allPairs.push(pool);
    }

    function allPairsLength() public view override returns (uint256) {
        return allPairs.length;
    }

    function getAllPairs() public view override returns (address[] memory) {
        return allPairs;
    }

    /// @inheritdoc IUniswapV3Factory
    /// @notice this function is called to set new default protocolFee for upcoming pools.
    function setAllPoolProtocolFee(
        uint8 _protocolFee
    ) public override {
        require(msg.sender == owner); //only manager
        protocolFee = _protocolFee;
    }

    /// @inheritdoc IUniswapV3Factory
    /// @notice this function is called to set new default protocolFeeTo for upcoming pools.
    function setAllPoolProtocolFeeTo(address newProtocolFeeTo) public override {
        require(msg.sender == owner); // only manager
        require(newProtocolFeeTo != protocolFeeTo);
        protocolFeeTo = newProtocolFeeTo;
    }
}
