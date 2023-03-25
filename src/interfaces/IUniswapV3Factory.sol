// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @title The interface for the Uniswap V3 Factory
/// @notice The Uniswap V3 Factory facilitates creation of Uniswap V3 pools and control over the protocol fees
interface IUniswapV3Factory {
    /// @notice Emitted when the owner of the factory is changed
    /// @param oldOwner The owner before the owner was changed
    /// @param newOwner The owner after the owner was changed
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);


 

    event ProtocolFeeToChanged(address indexed oldProtocolFeeTo, address indexed newProtocolFeeTo);



    function allPairs(uint) external view returns (address);

    function allPairsLength() external view returns (uint256);

    function getAllPairs() external view returns(address [] memory);

    /// @notice Returns the tick spacing for a given fee amount, if enabled, or 0 if not enabled
    /// @dev A fee amount can never be removed, so this value should be hard coded or cached in the calling context
    /// @param fee The enabled fee, denominated in hundredths of a bip. Returns 0 in case of unenabled fee
    /// @return The tick spacing
    function feeAmountTickSpacing(uint256 fee) external view returns (int256);

    /// @notice Returns the current address that holds protocolFee
    /// @dev Can be changed by the current owner via setAllPoolProtocolFeeTo
    /// @return The address of the protocolFee recipient
    function protocolFeeTo() external view returns (address);

    /// @notice Returns the default value of protocolFee 
    /// @dev Can be changed by the current owner via setAllPoolProtocolFee
    /// @return The default value of protocolFee of total trading fee for each pool
    function protocolFee() external view returns (uint8);

    /// @notice Returns the pool address for a given pair of tokens and a fee, or address 0 if it does not exist
    /// @dev tokenA and tokenB may be passed in either token0/token1 or token1/token0 order
    /// @param tokenA The contract address of either token0 or token1
    /// @param tokenB The contract address of the other token
    /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
    /// @return pool The pool address
    function getPool(address tokenA, address tokenB, uint256 fee) external view returns (address pool);

    /// @notice Creates a pool for the given two tokens and fee
    /// @param tokenA One of the two tokens in the desired pool
    /// @param tokenB The other of the two tokens in the desired pool
    /// @param fee The desired fee for the pool
    /// @dev tokenA and tokenB may be passed in either order: token0/token1 or token1/token0. tickSpacing is retrieved
    /// from the fee. The call will revert if the pool already exists, the fee is invalid, or the token arguments
    /// are invalid.
    /// @return pool The address of the newly created pool
    function createPool(address tokenA, address tokenB, uint256 fee) external returns (address pool);


    function setAllPoolProtocolFee(uint8 _protocolFee) external;

    function setAllPoolProtocolFeeTo(address newProtocolFeeTo) external;
}
