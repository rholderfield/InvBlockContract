//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./PurchaseOrderLineFactory.sol";

contract PurchaseOrderHeaderFactory is PurchaseOrderLineFactory {
    struct PurchaseOrderHeader {
        uint32 DocNumber;
        uint256 TransactionDate;
        uint256 SupplierId;
    }

    PurchaseOrderHeader[] public purchaseOrderHeaders;

    mapping(uint256 => address) public purchaseOrderHeaderToOwner;
    mapping(address => uint256) ownerPurchaseOrderHeaderCount;

    function createPurchaseOrderHeader(
        uint32 _DocNumber,
        uint256 _TransactionDate,
        uint256 _SupplierId,
        PurchaseOrderLine[] calldata newLines
    ) external {
        purchaseOrderHeaders.push(
            PurchaseOrderHeader(_DocNumber, _TransactionDate, _SupplierId)
        );

        uint256 id = purchaseOrderHeaders.length - 1;
        purchaseOrderHeaderToOwner[id] = msg.sender;
        ownerPurchaseOrderHeaderCount[msg.sender] =
            ownerPurchaseOrderHeaderCount[msg.sender] +
            1;

        for (uint256 i = 0; i < newLines.length; i++) {
            createPurchaseOrderLine(
                newLines[i].DocNumber,
                newLines[i].LineNo,
                newLines[i].ProductId,
                newLines[i].Quantity,
                newLines[i].Amount
            );
        }
    }

    function getPurchaseOrderHeaderByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](
            ownerPurchaseOrderHeaderCount[_owner]
        );
        uint256 counter = 0;
        for (uint256 i = 0; i < purchaseOrderHeaders.length; i++) {
            if (purchaseOrderHeaderToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
