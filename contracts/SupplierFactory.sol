//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SupplierFactory {
    event NewSupplier(uint256 id, uint256 SupplierId, string SupplierName);

    struct Supplier {
        uint256 SupplierId;
        string SupplierName;
        string SupplierPhone;
    }

    Supplier[] public suppliers;

    mapping(uint256 => address) public supplierToOwner;
    mapping(address => uint256) ownerSupplierCount;

    function createSupplier(
        uint256 _SupplierId,
        string calldata _SupplierName,
        string calldata _SupplierPhone
    ) external {
        suppliers.push(Supplier(_SupplierId, _SupplierName, _SupplierPhone));

        uint256 id = suppliers.length - 1;
        supplierToOwner[id] = msg.sender;
        ownerSupplierCount[msg.sender] = ownerSupplierCount[msg.sender] + 1;
        emit NewSupplier(id, _SupplierId, _SupplierName);
    }

    function getSupplierByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ownerSupplierCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < suppliers.length; i++) {
            if (supplierToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
