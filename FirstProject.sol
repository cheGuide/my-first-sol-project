// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract ENSregistration{
    

    struct ENS{
        address addr;
        uint timestamp;
        uint payment;
        uint ownsYears;
    }


    mapping(string => ENS) public list;
    address public owner;
    uint yearCost;
    uint coef;
    uint extPrice = yearCost * coef;


    constructor(){
        owner = msg.sender;
    }


    modifier onlyOwner(){
        require(owner == msg.sender, "NOT AN OWNER!!!");
        _;
    }


    modifier domenOwner(string memory _domen){
        require(list[_domen].addr == msg.sender, "You don't own this domen");
        _;
    }


    modifier maxMin(uint _year){
        require(_year >= 1 && _year <= 10, "out of value");
        _;
    }


    modifier checkDomen(string memory _domen){
        require(list[_domen].ownsYears*365 - (block.timestamp - list[_domen].timestamp)/86400 > 0, "This domain name is unavailable");
        _;
    }


    function setYearCost(uint _cost) public onlyOwner{
        yearCost = _cost;
    }
   

    function setCoef(uint _coef) public onlyOwner{
        coef = _coef;
    }


    function domenToAddr(string memory _domen, uint _year) public  payable maxMin(_year) checkDomen(_domen){
        list[_domen] = ENS({addr: msg.sender, timestamp: block.timestamp, payment: yearCost * _year, ownsYears: _year});
    }


    function addrToDomen(string memory _domen) public view returns(address){
        return list[_domen].addr;
    }


    function getBalance() public view returns(uint){
        return address(this).balance;
    }


    function minusMoney() public onlyOwner{
        address payable receiver = payable(msg.sender);
        receiver.transfer(getBalance());
    }


    /*
    function checkDomen(string memory _domen) public view returns(bool){
        uint daysLeft = list[_domen].ownsYears*365 - (block.timestamp - list[_domen].timestamp)/86400;
        return daysLeft > 0;
    }
    */


    function domenExtension(string memory _domen, uint _year) public domenOwner(_domen) maxMin(_year){
        list[_domen].timestamp = block.timestamp;
        list[_domen].payment += _year * extPrice;
    }
}

