// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Chat {
    struct Friend {
        address addressOfFriend;
        string name;
    }

    struct User {
        string name;
        Friend[] friends;
    }

    struct Message {
        address sender;
        uint256 timestamp;
        string msg;
    }

    struct AllUsers {
        string name;
        address addr;
    }

    mapping(address => User) usersList;
    mapping(bytes32 => Message[]) messages;
    AllUsers[] allUsers;

    function userExistsCheck(address _userAddr) public view returns (bool) {
        return bytes(usersList[_userAddr].name).length == 0;
    }

    function addUser(string memory _name) public {
        require(userExistsCheck(msg.sender), "User already exists!");
        require(bytes(_name).length > 0, "Need a user name.");

        usersList[msg.sender].name = _name;
        allUsers.push(AllUsers(_name, msg.sender));
    }

    function getUser(address _userAddr) public view returns (string memory) {
        require(userExistsCheck(_userAddr) == true, "User does not exits.");

        return usersList[_userAddr].name;
    }

    function addFriend(address _friendAddr, string memory name) public {
        require(userExistsCheck(msg.sender), "User does not exists!");
        require(userExistsCheck(_friendAddr), "User friend does not exits!");

        require(msg.sender != _friendAddr, "You cannot be your friend.");

        require(
            friendCheck(msg.sender, _friendAddr),
            "Both are already friends."
        );

        _addFriend(msg.sender, _friendAddr, name);
        _addFriend(_friendAddr, msg.sender, usersList[msg.sender].name);
    }

    function friendCheck(
        address _addr1,
        address _addr2
    ) internal view returns (bool) {
        if (
            usersList[_addr1].friends.length > usersList[_addr2].friends.length
        ) {
            address temp = _addr1;
            _addr1 = _addr2;
            _addr2 = temp;
        }

        for (uint256 i = 0; i < usersList[_addr1].friends.length; i++) {
            if (usersList[_addr1].friends[i].addressOfFriend == _addr2) {
                return true;
            }
        }
        return false;
    }

    function _addFriend(
        address _addr1,
        address _addr2,
        string memory _name
    ) internal {
        Friend memory friend = Friend(_addr2, _name);
        usersList[_addr1].friends.push(friend);
    }

    function getFriends(
        address _userAddr
    ) public view returns (Friend[] memory) {
        return usersList[_userAddr].friends;
    }

    function _getChatCode(
        address _addr1,
        address _addr2
    ) internal pure returns (bytes32) {
        if (_addr1 < _addr2) {
            return keccak256(abi.encodePacked(_addr1, _addr2));
        }

        return keccak256(abi.encodePacked(_addr2, _addr1));
    }

    function sendMessage(address _friendAddr, string memory _chat) public {
        require(userExistsCheck(msg.sender), "Create the account first.");
        require(userExistsCheck(_friendAddr), "User is not registered.");
        require(
            friendCheck(msg.sender, _friendAddr),
            "You are not friend with the given address user."
        );

        bytes32 chatCode = _getChatCode(msg.sender, _friendAddr);
        // Message memory msg=Message(msg.sender,block.timestamp,_chat);
        messages[chatCode].push(Message(msg.sender, block.timestamp, _chat));
    }

    function readMessage(
        address _friendAddr
    ) public view returns (Message[] memory) {
        bytes32 chatCode = _getChatCode(msg.sender, _friendAddr);
        return messages[chatCode];
    }

    function getAllUsers() public view returns (AllUsers[] memory) {
        return allUsers;
    }
}
