// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ggETH is ERC721 {
    address admin;

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function mint(address _account, uint256 _amount) external {
        require(msg.sender == admin, "TOGGE::mint: NOT_ADMIN");
        _mint(_account, _amount);
    }
}
