//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./SalesOrderLineFactory.sol";

contract SalesOrderHeaderFactory is SalesOrderLineFactory {
    struct SalesOrderHeader {
        uint32 DocNumber;
        uint256 TransactionDate;
        string Customer;
    }

    SalesOrderHeader[] public salesOrderHeaders;

    mapping(uint256 => address) public salesOrderHeaderToOwner;
    mapping(address => uint256) ownerSalesOrderHeaderCount;

    function createSalesOrderHeader(
        uint32 _DocNumber,
        uint256 _TransactionDate,
        string calldata _Customer,
        SalesOrderLine[] calldata newLines
    ) external {
        salesOrderHeaders.push(
            SalesOrderHeader(_DocNumber, _TransactionDate, _Customer)
        );

        uint256 id = salesOrderHeaders.length - 1;
        salesOrderHeaderToOwner[id] = msg.sender;
        ownerSalesOrderHeaderCount[msg.sender] =
            ownerSalesOrderHeaderCount[msg.sender] +
            1;

        // Need to add loop for lines
        for (uint256 i = 0; i < newLines.length; i++) {
            createSalesOrderLine(
                newLines[i].DocNumber,
                newLines[i].LineNo,
                newLines[i].ProductId,
                newLines[i].Quantity,
                newLines[i].Amount
            );
        }
    }

    function getSalesOrderHeaderByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](
            ownerSalesOrderHeaderCount[_owner]
        );
        uint256 counter = 0;
        for (uint256 i = 0; i < salesOrderHeaders.length; i++) {
            if (salesOrderHeaderToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
