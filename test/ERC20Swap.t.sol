// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ERC20Maker.sol";
import "../src/ERC20Swap.sol";

contract ERC20SwapTest is Test {
    ERC20Maker token1;
    ERC20Maker token2;
    ERC20Swap swapper;

    address owner1 = address(0x1);
    string name1 = "Token 1";
    string symbol1 = "TOK1";
    address owner2 = address(0x2);
    string name2 = "Token 2";
    string symbol2 = "TOK2";

    function setUp() public {
        vm.startPrank(owner1);
        token1 = new ERC20Maker(name1, symbol1);
        vm.stopPrank();

        vm.startPrank(owner2);
        token2 = new ERC20Maker(name2, symbol2);
        vm.stopPrank();

        swapper = new ERC20Swap(owner1, owner2, token1, token2);
    }

    function testSwapNotOwner() public {
        vm.expectRevert("Not owner.");
        swapper.swap(1000000000000000000, 1000000000000000000);
    }

    function testSwapNoAllowance() public {
        vm.startPrank(owner1);
        vm.expectRevert("Not enough funds allowed.");
        swapper.swap(10 ether, 20 ether);
        vm.stopPrank();
    }

    function testSwapOks() public {
        vm.startPrank(owner1);
        token1.approve(address(swapper), 10 ether);
        vm.stopPrank();

        vm.startPrank(owner2);
        token2.approve(address(swapper), 20 ether);
        swapper.swap(10 ether, 20 ether);
        vm.stopPrank();

        assertEq(token1.balanceOf(owner2), 10 ether);
        assertEq(token2.balanceOf(owner1), 20 ether);
    }
}
