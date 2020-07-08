// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.7.0;

contract EWill {
    address payable owner;
    address nominee;

    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event NomineeChanged(
        address indexed previousNominee,
        address indexed newNominee
    );

    constructor(address _nominee) public {
        require(
            _nominee != address(0),
            "Error: new nominee is the zero address"
        );
        owner = msg.sender;
        nominee = _nominee;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Error: Not owner");
        _;
    }

    function transferOwnership(address payable _newOwner) public onlyOwner {
        require(
            _newOwner != address(0),
            "Error: new owner is the zero address"
        );
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    function changeNominee(address _nominee) public onlyOwner {
        require(
            _nominee != address(0),
            "Error: new nominee is the zero address"
        );
        emit NomineeChanged(owner, _nominee);
        nominee = _nominee;
    }

    function checkIn() public onlyOwner {
        //TODO
    }

    function withdraw(uint256 value) public onlyOwner {
        owner.transfer(value);
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}
