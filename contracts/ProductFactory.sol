//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract ProductFactory {
    event NewProduct(uint256 id, uint256 ProductId, string ProductName);

    struct Product {
        uint256 ProductId;
        string ProductName;
        string PartNumber;
        string ProductDescription;
    }

    Product[] public products;

    mapping(uint256 => address) public productToOwner;
    mapping(address => uint256) ownerProductCount;

    function createProduct(
        uint256 _ProductId,
        string calldata _ProductName,
        string calldata _PartNumber,
        string calldata _ProductDescription
    ) external {
        products.push(
            Product(_ProductId, _ProductName, _PartNumber, _ProductDescription)
        );

        uint256 id = products.length - 1;
        productToOwner[id] = msg.sender;
        ownerProductCount[msg.sender] = ownerProductCount[msg.sender] + 1;
        emit NewProduct(id, _ProductId, _ProductName);
    }

    function getProductByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ownerProductCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < products.length; i++) {
            if (productToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function getProductByOwnerCount() external view returns (uint256) {
        return ownerProductCount[msg.sender];
    }
}
