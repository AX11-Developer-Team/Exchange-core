// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "../V3CoreErrors.sol";

/// @title Safe casting methods
/// @notice Contains methods for safely casting between types
/// Note All functions are imported from Openzeppelin https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeCast.sol
library SafeCast {
   /**
     * @dev Returns the downcasted uint160 from uint256, reverting on
     * overflow (when the input is greater than largest uint160).
     *
     * Counterpart to Solidity's `uint160` operator.
     *
     * Requirements:
     *
     * - input must fit into 160 bits
     *
     * _Available since v4.7._
     */
    function toUint160(uint256 value) internal pure returns (uint160) {
        // require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
        if (value > type(uint160).max) revert UINT_TO_UINT160();
        return uint160(value);
    }


    /**
     * @dev Returns the downcasted int128 from int256, reverting on
     * overflow (when the input is less than smallest int128 or
     * greater than largest int128).
     *
     * Counterpart to Solidity's `int128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     *
     * _Available since v3.1._
     */
    function toInt128(int256 value) internal pure returns (int128 downcasted) {
        downcasted = int128(value);
        // require(downcasted == value, "SafeCast: value doesn't fit in 128 bits");
        if (downcasted != value) revert INT_TO_INT128();
    }

   /**
     * @dev Converts an unsigned uint256 into a signed int256.
     *
     * Requirements:
     *
     * - input must be less than or equal to maxInt256.
     *
     * _Available since v3.0._
     */
    function toInt256(uint256 value) internal pure returns (int256) {
        // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
        // require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
        if (value > uint256(type(int256).max)) revert UINT_TO_INT();
        return int256(value);
    }
}
