pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

//import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

contract YourCollectible is ERC1155, ERC1155Burnable, Ownable {
	uint256 private _currentTokenID = 0;
	uint256 private _apeId;
	uint256 private _bearId;
	mapping(uint256 => uint256) public tokenSupply;

	constructor(string memory _uri, uint256 _apeID, uint256 _bearID) ERC1155(_uri) {
		_apeId = _apeID;
		_bearId = _bearID;
	}

	modifier isApeOwner(address _addr, uint amount) {
		require(balanceOf(_addr, _apeId) >= amount, "You don't have enough ape");
		_;
	}

	function mint(
		address _to,
		uint256 _id,
		uint256 _quantity,
		bytes memory _data
	) public onlyOwner
	{
		if(tokenSupply[_id] == 0)
		require(_id == _currentTokenID, "Wrong id provided");

		_mint(_to, _id, _quantity, _data);
		tokenSupply[_id] = tokenSupply[_id] + _quantity;
		_incrementTokenTypeId();
	}

  	/**
		* @dev calculates the next token ID based on value of _currentTokenID
		* @return uint256 for the next token ID
	 */
	function _getNextTokenID() private view returns (uint256) {
		  return _currentTokenID + 1;
	}

	/**
	 * @dev increments the value of _currentTokenID
	 */
	function _incrementTokenTypeId() private {
		  _currentTokenID++;
	}

    function getCurrentTokenID() public view returns(uint256){
        return _currentTokenID;
    }

    function mutateApeToBear(uint _amt) external isApeOwner(msg.sender, _amt) {
        address user = msg.sender;
        burn(user, _apeId, _amt);
        mint(user, _bearId, _amt, "");
    }

    function setApeID(uint256 _id) public onlyOwner {
        _apeId = _id;
    }

    function setBearID(uint256 _id) public onlyOwner {
        _bearId = _id;
    }
}