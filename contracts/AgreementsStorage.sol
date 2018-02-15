pragma solidity 0.4.18;

import "./Ownable.sol";

contract AgreementsStorage is Ownable {
    struct Agreement {
        address uploader;
        address partner;
        bytes name;
        bytes ipfsHash;
        bytes uploaderKey;
        bytes partnerKey;
        bool isConfirmed;
    }

    mapping (uint => Agreement) public agreements;
    mapping (address => uint[]) public allAgreements;

    function setAgreementConfirmed(uint agreementId) external onlyOwner {
        agreements[agreementId].isConfirmed = true;
    }

    function setAgreement(uint agreementId,
        address _uploader,
        address _partner,
        bytes _name,
        bytes _ipfsHash,
        bytes _uploaderKey,
        bytes _partnerKey)
        external
        onlyOwner
        {
            agreements[agreementId] = Agreement({
                uploader: _uploader,
                partner: _partner,
                name: _name,
                ipfsHash: _ipfsHash,
                uploaderKey: _uploaderKey,
                partnerKey: _partnerKey,
                isConfirmed: false
            });
            allAgreements[_uploader].push(agreementId);
            allAgreements[_partner].push(agreementId);
    }

    function getIndexForAgreementId(uint agreementId,
        address uploader,
        address partner )
        external
        view
        returns
        (uint indexOfUploader, uint indexOfPartner)
        {
            for (uint i = 0; i < allAgreements[uploader].length; i++) {
                if (allAgreements[uploader][i] == agreementId) {
                    indexOfUploader = i;
                    break;
                }
            }

            for (i = 0; i < allAgreements[partner].length; i++) {
                if (allAgreements[partner][i] == agreementId) {
                    indexOfPartner = i;
                    break;
                }
            }
    }

    function deleteUnconfirmedAgreement(uint agreementId,
        address uploader,
        address partner,
        uint indexOfUploader,
        uint indexOfPartner)
        external
        onlyOwner
        {
            require(!agreements[agreementId].isConfirmed
                && agreements[agreementId].uploader == uploader
                && agreements[agreementId].partner == partner);
            require(allAgreements[uploader][indexOfUploader] == agreementId
                && allAgreements[partner][indexOfPartner] == agreementId);
            delete agreements[agreementId];
            allAgreements[uploader][indexOfUploader] = allAgreements[uploader][allAgreements[uploader].length - 1];
            delete allAgreements[uploader][allAgreements[uploader].length - 1];
            allAgreements[partner][indexOfPartner] = allAgreements[partner][allAgreements[partner].length - 1];
            delete allAgreements[partner][allAgreements[partner].length - 1];
    }

    function getAgreementUploader(uint agreementId) public view returns(address){
        return agreements[agreementId].uploader;
    }

    function getAgreementPartner(uint agreementId) public view returns(address){
        return agreements[agreementId].partner;
    }

    function getAgreementFileName(uint agreementId) public view returns(bytes){
        return agreements[agreementId].name;
    }

    function getAgreementFileIPFSHash(uint agreementId) public view returns(bytes){
        return agreements[agreementId].ipfsHash;
    }

    function getAgreementFileUploaderKey(uint agreementId) public view returns(bytes){
        return agreements[agreementId].uploaderKey;
    }

    function getAgreementFilePartnerKey(uint agreementId) public view returns(bytes){
        return agreements[agreementId].partnerKey;
    }

    function getAgreementConfirmed(uint agreementId) public view returns(bool) {
        return agreements[agreementId].isConfirmed;
    }

    function getAllAgreementsArray(address _address) public view returns(uint[]) {
        return allAgreements[_address];
    }

}
