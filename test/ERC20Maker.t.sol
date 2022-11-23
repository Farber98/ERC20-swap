// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ERC20Maker.sol";

contract ERC20MakerTest is Test {
    ERC20Maker token1;
    ERC20Maker token2;

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
    }

    function testNameOk() public {
        assertEq(token1.name(), name1);
        assertEq(token2.name(), name2);
    }

    function testSymbolOk() public {
        assertEq(token1.symbol(), symbol1);
        assertEq(token2.symbol(), symbol2);
    }

    function testDecimalsAre18() public {
        assertEq(token1.decimals(), 18);
        assertEq(token2.decimals(), 18);
    }

    function testTotalSupplyIs100() public {
        assertEq(token1.totalSupply(), 100 * 10**token1.decimals());
        assertEq(token2.totalSupply(), 100 * 10**token2.decimals());
    }

    function testTotalSupplyInOwnerAccount() public {
        assertEq(token1.balanceOf(owner1), token1.totalSupply());
        assertEq(token2.balanceOf(owner2), token1.totalSupply());
    }
}
