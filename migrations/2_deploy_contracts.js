/** @format */

const EWill = artifacts.require("EWill");

module.exports = function (deployer, network, accounts) {
	// Number of blocks in a year with average block time of 15s.
	const MIN_BLOCK_BUFFER = 2102400;
	deployer.deploy(EWill, accounts[1], MIN_BLOCK_BUFFER);
};
