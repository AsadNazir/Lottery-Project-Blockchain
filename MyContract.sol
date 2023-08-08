// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract LotteryContract {
    address public manager;
    //It means it can receive ethers transfers
    address payable[] public players;
    //Winner will get the lottery
    address payable public winner;

    //contructors
    constructor() {
        //The person who deploys the contract
        //Manager in our case
        manager = msg.sender;
    }

    receive() external payable {

        require(msg.value == 0.000001 ether);
        //to convert it into the payable amount instead of normal address
        players.push(payable(msg.sender));
    }

    function getBalance () public view returns(uint )
    {
        require(msg.sender == manager);
        return address(this).balance;
    }

    // function randomNumber() public view returns (uint)
    // {
    //    keccak256( abi.encodePacked(block.difficulty, block.timestamp, players.length));
    // }
    function randomNumber() public view returns (uint) {
        bytes memory packedData = abi.encodePacked(block.basefee, block.timestamp, block.coinbase, players.length);
        bytes32 hash = keccak256(packedData);
        return uint(hash);
    }

    function pickWinner() public
    {
        require(msg.sender == manager);
        require(players.length >=3);

        uint w = randomNumber();
        uint index = w % players.length;
        winner = players[index];
        winner.transfer(getBalance());

        players = new address payable [](0);

    }

}
