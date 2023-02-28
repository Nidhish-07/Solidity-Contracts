// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.0;

contract Messenger {
    //only the owner can send messages

    uint public messageCount;

    string public message;

    address private owner;

    constructor() {
        owner = msg.sender;
    }

    function sendMessage(string memory _message) public {
        if (msg.sender == owner) {
            message = _message;
            messageCount++;
        }
    }
}
