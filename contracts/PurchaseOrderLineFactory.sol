//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract PurchaseOrderLineFactory {
    struct PurchaseOrderLine {
        uint32 DocNumber;
        uint32 LineNo;
        uint256 ProductId;
        uint256 Quantity;
        int256 Amount;
    }

    PurchaseOrderLine[] public purchaseOrderLines;

    mapping(uint256 => address) public purchaseOrderLineToOwner;
    mapping(address => uint256) ownerPurchaseOrderLineCount;

    function createPurchaseOrderLine(
        uint32 _DocNumber,
        uint32 _LineNo,
        uint256 _ProductId,
        uint256 _Quantity,
        int256 _Amount
    ) internal {
        purchaseOrderLines.push(
            PurchaseOrderLine(
                _DocNumber,
                _LineNo,
                _ProductId,
                _Quantity,
                _Amount
            )
        );

        uint256 id = purchaseOrderLines.length - 1;
        purchaseOrderLineToOwner[id] = msg.sender;
        ownerPurchaseOrderLineCount[msg.sender] =
            ownerPurchaseOrderLineCount[msg.sender] +
            1;
    }

    function getPurchaseOrderLineByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](
            ownerPurchaseOrderLineCount[_owner]
        );
        uint256 counter = 0;
        for (uint256 i = 0; i < purchaseOrderLines.length; i++) {
            if (purchaseOrderLineToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
