// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";

contract ERC20Swap {
    address public owner1;
    address public owner2;
    IERC20 token1;
    IERC20 token2;

    constructor(
        address _owner1,
        address _owner2,
        IERC20 _token1,
        IERC20 _token2
    ) {
        owner1 = _owner1;
        owner2 = _owner2;
        token1 = _token1;
        token2 = _token2;
    }

    modifier onlyOwners() {
        require(msg.sender == owner1 || msg.sender == owner2, "Not owner.");
        _;
    }

    modifier enoughFunds(uint256 _amount1, uint256 _amount2) {
        require(
            token1.allowance(owner1, address(this)) >= _amount1 &&
                token2.allowance(owner2, address(this)) >= _amount2,
            "Not enough funds allowed."
        );
        _;
    }

    function swap(uint256 _amount1, uint256 _amount2)
        public
        onlyOwners
        enoughFunds(_amount1, _amount2)
    {
        safeTransferFrom(token1, owner1, owner2, _amount1);
        safeTransferFrom(token2, owner2, owner1, _amount2);
    }

    function safeTransferFrom(
        IERC20 _token,
        address _sender,
        address _receiver,
        uint256 _amount
    ) private {
        bool sent = _token.transferFrom(_sender, _receiver, _amount);
        require(sent, "Transaction failed.");
    }
}
