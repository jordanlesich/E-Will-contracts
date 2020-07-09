// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.7.0;

contract EWill {
    address payable public owner;
    address payable public nominee;
    uint256 public lastCheckInBlock;
    uint256 public minBlockBuffer;
    bool isMissing;

    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event NomineeChanged(
        address indexed previousNominee,
        address indexed newNominee
    );

    constructor(address payable _nominee, uint256 _minBlockBuffer) public {
        require(_nominee != address(0), "Error: nominee is the zero address");
        owner = msg.sender;
        nominee = _nominee;
        lastCheckInBlock = block.number;
        minBlockBuffer = _minBlockBuffer;
        isMissing = false;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Error: Not owner");
        _;
    }

    modifier onlyNominee() {
        require(msg.sender == nominee, "Not a nominee");
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

    function changeNominee(address payable _nominee) public onlyOwner {
        require(
            _nominee != address(0),
            "Error: new nominee is the zero address"
        );
        emit NomineeChanged(owner, _nominee);
        nominee = _nominee;
    }

    function checkIn() public onlyOwner {
        lastCheckInBlock = block.number;
    }

    function hasGoneMissing() public returns (bool) {
        if (block.number - lastCheckInBlock > minBlockBuffer) {
            isMissing = true;
        } else {
            return false;
        }
        return isMissing;
    }

    function withdrawFunds(uint256 value) public onlyOwner {
        owner.transfer(value);
    }

    function claimInheritence() public onlyNominee {
        require(isMissing, "Error: was active recently");
        nominee.transfer(address(this).balance);
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}
