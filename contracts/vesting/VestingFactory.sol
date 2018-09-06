pragma solidity ^0.4.21;

import '../ownership/Ownable.sol';
import './TokenVesting.sol';


contract TokenVestingFactory is Ownable {
    event Created(TokenVesting vesting);

    function create( address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration ) onlyOwner public returns (TokenVesting) {
        TokenVesting vesting = new TokenVesting(
            _beneficiary,
            _start,
            _cliff,
            _duration,
            true
        );

        vesting.transferOwnership(msg.sender);

        emit Created(vesting);
        return vesting;
    }
}