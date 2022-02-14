//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SalesOrderLineFactory {
    struct SalesOrderLine {
        uint32 DocNumber;
        uint32 LineNo;
        uint256 ProductId;
        uint256 Quantity;
        int256 Amount;
    }

    SalesOrderLine[] public salesOrderLines;

    mapping(uint256 => address) public salesOrderLineToOwner;
    mapping(address => uint256) ownerSalesOrderLineCount;

    function createSalesOrderLine(
        uint32 _DocNumber,
        uint32 _LineNo,
        uint256 _ProductId,
        uint256 _Quantity,
        int256 _Amount
    ) internal {
        salesOrderLines.push(
            SalesOrderLine(_DocNumber, _LineNo, _ProductId, _Quantity, _Amount)
        );

        uint256 id = salesOrderLines.length - 1;
        salesOrderLineToOwner[id] = msg.sender;
        ownerSalesOrderLineCount[msg.sender] =
            ownerSalesOrderLineCount[msg.sender] +
            1;
    }

    function getSalesOrderLineByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](
            ownerSalesOrderLineCount[_owner]
        );
        uint256 counter = 0;
        for (uint256 i = 0; i < salesOrderLines.length; i++) {
            if (salesOrderLineToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
