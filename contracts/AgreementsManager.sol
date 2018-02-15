pragma solidity 0.4.18;

import "./AgreementsStorage.sol";
import "./Ownable.sol";

contract AgreementsManager is Ownable {
    address public storageAddress;

    uint public transactionCount;

    modifier agreementExists(uint transactionId) {
        require(AgreementsStorage(storageAddress).getAgreementPartner(transactionId) != address(0x0));
        _;
    }

    modifier notConfirmed(uint transactionId) {
        require(!AgreementsStorage(storageAddress).getAgreementConfirmed(transactionId));
        _;
    }

    modifier isPartner(uint transactionId) {
        require(AgreementsStorage(storageAddress).getAgreementPartner(transactionId) == msg.sender);
        _;
    }

    modifier nonZeroPartner(address partner) {
        require(partner != address(0x0));
        _;
    }

    modifier partnerIsNotUploader(address partner) {
        require(partner != msg.sender);
        _;
    }

    function AgreementsManager(address _storageAddress) public Ownable() {
        storageAddress = _storageAddress;
    }

    function submitAgreement(address partner, bytes name, bytes ipfsHash, bytes uploaderKey, bytes partnerKey )
        public
        nonZeroPartner(partner)
        partnerIsNotUploader(partner)
    {
        uint transactionId = transactionCount++;
        AgreementsStorage(storageAddress).setAgreement(transactionId,
            msg.sender,
            partner,
            name,
            ipfsHash,
            uploaderKey,
            partnerKey);
    }

    function confirmAgreement(uint transactionId)
        public
        agreementExists(transactionId)
        notConfirmed(transactionId)
        isPartner(transactionId)
    {
        AgreementsStorage(storageAddress).setAgreementConfirmed(transactionId);
    }

    function revokeAgreementForUploader(uint agreementId, address partner, uint indexOfUploader, uint indexOfPartner)
        public

    {
        AgreementsStorage(storageAddress).deleteUnconfirmedAgreement(agreementId,
            msg.sender,
            partner,
            indexOfUploader,
            indexOfPartner);
    }

    function revokeAgreementForPartner(uint agreementId, address uploader, uint indexOfUploader, uint indexOfPartner)
        public

    {
        AgreementsStorage(storageAddress).deleteUnconfirmedAgreement(agreementId,
            uploader,
            msg.sender,
            indexOfUploader,
            indexOfPartner);
    }

    function transferOwnerShipOfAgreementStorage(address newOwner) public onlyOwner {
        AgreementsStorage(storageAddress).transferOwnership(newOwner);
        selfdestruct(owner);
    }

}
