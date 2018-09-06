pragma solidity ^0.4.18;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

/**
 * @title EthPriceOraclize
 * @dev Using oraclize for getting ETH price from coinmarketcap
 */
contract EthPriceOraclize is usingOraclize {
    address public owner;
    uint256 public delay = 43200; // 12 hours for pre-sale
    uint256 public ethDefaultPrice;
    uint256 public ETHUSD;

    event OraclizeCreated(address _oraclize);
    event LogInfo(string description);
    event LogPriceUpdate(uint256 price);

    function() external payable {
        update(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function EthPriceOraclize() public {
        owner = msg.sender;
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);

        emit OraclizeCreated(this);
        update(0);
    }

    function __callback(bytes32 id, string result, bytes proof) public {
        require(msg.sender == oraclize_cbAddress());

        ETHUSD = parseInt(result);
        LogPriceUpdate(ETHUSD);

        update(delay);
    }

    function update(uint256 _delay) payable public {
        if (oraclize_getPrice("URL") > address(this).balance) {
            ETHUSD = ethDefaultPrice;
            LogInfo("Oraclize query was NOT sent, please add some ETH to cover for the query fee!");
        } else {
            LogInfo("Oraclize query was sent, standing by for the answer ...");
            oraclize_query(_delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd");
        }
    }

    function setETHPriceManually(uint256 _price) public onlyOwner {
        ethDefaultPrice = _price;
    }

    function changeQueryDelay(uint256 _newDelay) public onlyOwner {
        delay = _newDelay;
    }

    function getEthPrice() public view returns (uint256) {
        return ETHUSD;
    }

}