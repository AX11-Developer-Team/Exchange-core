// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "./interfaces/IUniswapV3Factory.sol";
import "./interfaces/pool/IUniswapV3PoolOwnerActions.sol";
import "./interfaces/IFactoryManager.sol";

/// @title The manager contract of Factory]
/// Note the purpose of this contract implementation is to split the size of factory contract without the use of delegatecall, for better compilation and deployment
/// @notice This contract contains only function performed by Factory owner
/// @notice This contract is deployed before factory
/// @notice This contract address is used to deploy factory and has the factory owner role
contract FactoryManager is IFactoryManager {
    error ALREADY_SET();
    address public override MANAGER;
    address public override FACTORY;
    bool public override FACTORY_SET;

    constructor() {
        MANAGER = msg.sender;
        FACTORY_SET = false;
    }

    modifier onlyManager() {
        _onlyManager();
        _;
    }

    function _onlyManager() private view {
        require(msg.sender == MANAGER);
    }

    function unsafe_increment(uint256 i) internal pure returns (uint) {
        unchecked {
            ++i;
        }
        return (i);
    }

    ////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////
    /////////                            OPERATION                           ///////////
    ////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////


    /// @notice once the factory address is set, it becomes immutable.
    function setFactory(address _factory) external override onlyManager {
        if (FACTORY_SET) revert ALREADY_SET();
        FACTORY = _factory;
        FACTORY_SET = true;
    }

    function setOwner(address _MANAGER) external override onlyManager {
        MANAGER = _MANAGER;
    }

    function ManagerSetAllPoolProtocolFee(
        uint8 pfToken0,
        uint8 pfToken1
    ) external override onlyManager {
        // require(msg.sender == owner);
        /// Note the inputs will take effect in the form of (1/x) for each token of all deployed and not-yet deployed pools
        /// Note inputs can only be 2 >= x <= 10 which represent 1/2 to 1/10
        require(
            (pfToken0 == 0 || (pfToken0 >= 2 && pfToken0 <= 10)) &&
                (pfToken1 == 0 || (pfToken1 >= 2 && pfToken1 <= 10))
        );
        //Change the default protocolFee value for upcoming pool deployments
        //This goes first to make sure there is not a miss when new contracts are deploed during the loop below
        uint8 _protocolFee = pfToken0 + (pfToken1 << 4);
        IUniswapV3Factory xuniswapv3factory = IUniswapV3Factory(FACTORY);
        xuniswapv3factory.setAllPoolProtocolFee(_protocolFee);

        //Change protocolFee for the existing(deployed) pools
        uint256 x = xuniswapv3factory.allPairsLength();
        address[] memory _allPairs = xuniswapv3factory.getAllPairs();

        for (uint i = 0; i < x; i = unsafe_increment(i)) {
            IUniswapV3PoolOwnerActions xuniswapv3poolowneractions = IUniswapV3PoolOwnerActions(
                    _allPairs[i]
                );
            xuniswapv3poolowneractions.setFeeProtocol(_protocolFee);
        }
    }

    function ManagerSetAllPoolProtocolFeeTo(
        address newProtocolFeeTo
    ) external override onlyManager {
        //Change the default protocolFeeTo address for upcoming pool deployments
        //This goes first to make sure there is not a miss when new contracts are deploed during the loop below
        IUniswapV3Factory xuniswapv3factory = IUniswapV3Factory(FACTORY);
        xuniswapv3factory.setAllPoolProtocolFeeTo(newProtocolFeeTo);

        //Change protocolFeeTo for the existing(deployed) pools
        uint256 x = xuniswapv3factory.allPairsLength();
        address[] memory _allPairs = xuniswapv3factory.getAllPairs();
        for (uint i = 0; i < x; i = unsafe_increment(i)) {
            IUniswapV3PoolOwnerActions xuniswapv3poolowneractions = IUniswapV3PoolOwnerActions(
                    _allPairs[i]
                );
            xuniswapv3poolowneractions.setFeeProtocolTo(newProtocolFeeTo);
        }
    }
}
