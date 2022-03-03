// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;         //Compiler version >=0.8.7

contract HelloWorld {
    //declaring unsigned public integer.
    uint public unsignedInt = 1;

    //adding a constructor
    constructor() {
    }

    //function to set unsignedInt's value
    function set(uint _unsignedInt) public{
        unsignedInt = _unsignedInt;
    }

    //since unsignedInt is public there is no need for a specific getter method, but will still add a method to retrive it incase the accessor changes
    function retrieve() public view returns(uint) {
        return unsignedInt;
    }


}