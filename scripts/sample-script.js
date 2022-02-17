// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  await hre.run("compile");

  // We get the contract to deploy
  //
  const ProductFactory = await hre.ethers.getContractFactory("ProductFactory");
  const productFactory = await ProductFactory.deploy();

  await productFactory.deployed();

  console.log("ProductFactory deployed to:", productFactory.address);
  //

  const SupplierFactory = await hre.ethers.getContractFactory(
    "SupplierFactory"
  );
  const supplierFactory = await SupplierFactory.deploy();

  await supplierFactory.deployed();

  console.log("SupplierFactory deployed to:", supplierFactory.address);
  //

  const PurchaseOrderHeaderFactory = await hre.ethers.getContractFactory(
    "PurchaseOrderHeaderFactory"
  );
  const purchaseOrderHeaderFactory = await PurchaseOrderHeaderFactory.deploy();

  await purchaseOrderHeaderFactory.deployed();

  console.log(
    "PurchaseOrderHeaderFactory deployed to:",
    purchaseOrderHeaderFactory.address
  );
  //

  const SalesOrderHeaderFactory = await hre.ethers.getContractFactory(
    "SalesOrderHeaderFactory"
  );
  const salesOrderHeaderFactory = await SalesOrderHeaderFactory.deploy();

  await salesOrderHeaderFactory.deployed();

  console.log(
    "SalesOrderHeaderFactory deployed to:",
    salesOrderHeaderFactory.address
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
