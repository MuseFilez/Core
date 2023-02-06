/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-ethers");

const accessControlConditions = [
  {
    contractAddress: '0xA80617371A5f511Bf4c1dDf822E6040acaa63e71',
    standardContractType: 'ERC721',
    chain,
    method: 'balanceOf',
    parameters: [
      ':userAddress'
    ],
    returnValueTest: {
      comparator: '>',
      value: '0'
    }
  }
]

module.exports = {
  solidity: "0.8.17",
};
