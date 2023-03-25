// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @title The interface factory manager
interface IFactoryManager {

    function MANAGER() external view returns(address);
    function FACTORY() external view returns(address);
    function FACTORY_SET() external view returns(bool);

    function setFactory(address) external;
    function setOwner(address) external;

    function ManagerSetAllPoolProtocolFee(uint8 pfToken0, uint8 pfToken1) external;
    function ManagerSetAllPoolProtocolFeeTo(address newProtocolFeeTo) external;



}