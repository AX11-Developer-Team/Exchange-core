// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

///////////////////////////////////////////////
// Libraries
///////////////////////////////////////////////

// FullMath.sol
error FULLMATH_OVERFLOW();

// SafeCast.sol
error UINT_TO_UINT160();
error INT_TO_INT128();
error UINT_TO_INT();

// TickMath.sol
error MAX_TICK_EXCEED();
error MAX_SQRT_EXCEED();

// TickBitmap.sol
error FLIP_TICK();

// TransferHelper.sol
error TRANSFER_FAILED();

// Oracle.sol
error CURRENT_ZERO();
error OLD_OBSERVATION();
error CARDINALITY_ZERO();

// Position.sol
error UPDATE_LPZERO();

// SqrtPriceMath.sol
error SQR_LP_IN_ZERO();
error SQR_LP_OUT_ZERO();

// Tick.sol
error LG_EXCEED();

///////////////////////////////////////////////
// Contracts
///////////////////////////////////////////////

// UniswapV3Pool.sol
error LOCK();
error TICK_ERROR();
error TICK_L_EXCEED();
error TICK_U_EXCEED();
error POOL_INITIALIZED();
error M0_EXCEED_B0();
error M1_EXCEED_B1();
error AMOUNT_SPECIFIED_ZERO();
error IIA();
error LIQUIDITY_ZERO();
error FEE_0();
error FEE_1();
