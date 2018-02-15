pragma solidity 0.4.18;

import './Ownable.sol';

contract User is Ownable {
  mapping (address => bool) public isRegisteredUser;
  mapping (address => string) public userRsaIpfsHash;

  modifier checkRegisteredUser() {
    if (!isRegisteredUser[msg.sender])
    _;
  }

  function setUserRsaIpfsHash(string ipfsHash) checkRegisteredUser {
    userRsaIpfsHash[msg.sender] = ipfsHash;
    isRegisteredUser[msg.sender] = true;
  }
}
