// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IERC20Minimal} from '../interfaces/IERC20Minimal.sol';
import '../V3CoreErrors.sol';

/// @title TransferHelper
/// @notice Contains helper methods for interacting with ERC20 tokens that do not consistently return true/false
library TransferHelper {
    /// @notice Transfers tokens from msg.sender to a recipient
    /// @dev Calls transfer on token contract, errors with TRANSFER_FAILED if transfer fails
    /// @param token The contract address of the token which will be transferred
    /// @param to The recipient of the transfer
    /// @param value The value of the transfer
    function safeTransfer(address token, address to, uint256 value) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20Minimal.transfer.selector, to, value)
        );
        if (!(success && (data.length == 0 || abi.decode(data, (bool))))) revert TRANSFER_FAILED();
    }
}
