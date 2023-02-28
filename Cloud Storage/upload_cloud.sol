// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.0;

contract upload {
    struct Access {
        address user;
        bool access;
    }

    mapping(address => string[]) upload_url;

    mapping(address => mapping(address => bool)) sharedUser;

    mapping(address => Access[]) userAccess;

    mapping(address => mapping(address => bool)) oldData;

    function add( address _user,string memory _url) external {
        upload_url[_user].push(_url);
    }

    function allow(address user) external {
        sharedUser[msg.sender][user] = true;
        if (oldData[msg.sender][user]) {
            for (uint256 i = 0; i < userAccess[msg.sender].length; i++) {
                if (userAccess[msg.sender][i].user == user) {
                    userAccess[msg.sender][i].access = true;
                }
            }
        } else {
            userAccess[msg.sender].push(Access(user, true));
            oldData[msg.sender][user] = true;
        }
    }

    function disAllow(address user) external{
        sharedUser[msg.sender][user]=false;
        
        for(uint i=0;i<userAccess[msg.sender].length;i++){

            if(userAccess[msg.sender][i].user==user){
                userAccess[msg.sender][i].access=false;
            }
        }
    }

    function display(address _user) external view returns(string[] memory){
        require(_user==msg.sender||sharedUser[_user][msg.sender],"You are not authorized");
return upload_url[_user];
    }

    function sharedAccess() public view returns(Access[] memory){
        return userAccess[msg.sender];
    }


}
