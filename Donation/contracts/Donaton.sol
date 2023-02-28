// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.0;

contract Donate{

//the entity who want the donations
    address payable owner;

    constructor(){
        owner=payable(msg.sender);
    }

    struct Donation{
        string name;
        string message;
        address from;
        uint256 timestamp;
    }

    Donation[] donations;


    function sendDonation(string memory _name,string memory _message) public payable 
    {
        require(msg.value>0,"Please send a valid amount.");
        owner.transfer(msg.value); //the person will get the donation
        donations.push(Donation(_name,_message,msg.sender,block.timestamp));
    }

    function getDonations () public view returns(Donation[] memory){
        return donations;
    }
}