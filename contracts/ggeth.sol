// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract ggETH is ERC721 {

    address admin;
    mapping(address => uint) public lpBalance;

    constructor(
        string memory name,
        string memory symbol
    )ERC721(name, symbol) {
        admin = msg.sender;
    }

    modifier isAdmin(){
        require(msg.sender == admin,"TOGGE::mint: NOT_ADMIN");
        _;
    }


    function mint(address _account, uint id,uint _lpBalance) external isAdmin{
        require(msg.sender == admin,"TOGGE::mint: NOT_ADMIN");
        lpBalance[msg.sender] = _lpBalance;
        _mint(_account,_amount);
    }

    function exists(uint _id) external isAdmin{
        return _exists(_id);
    }


}


