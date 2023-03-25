// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "forge-std/Test.sol";
import {BitMathTest} from "../src/test/BitMathTest.sol";

contract test_BitMathTest is Test {
    BitMathTest bitmathtest;

    function setUp() public {
        bitmathtest = new BitMathTest();
    }

    function test_mostSignificantBit() public {
        assertEq(bitmathtest.mostSignificantBit(1), 0);
        assertEq(bitmathtest.mostSignificantBit(2), 1);

        for (uint256 i = 0; i <= 255; i++) {
            assertEq(bitmathtest.mostSignificantBit(2 ** i), i);
        }

        assertEq(bitmathtest.mostSignificantBit(type(uint).max), 255);

        vm.expectRevert();
        bitmathtest.mostSignificantBit(0);
        vm.expectRevert();
        bitmathtest.mostSignificantBit(type(uint).max + 1);
    }

    // function test_leastSignificantBit() public {

    // }


    

}