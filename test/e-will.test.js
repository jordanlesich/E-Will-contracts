/** @format */

const chai = require("chai");
chai.use(require("chai-as-promised"));

const expect = chai.expect;

const EWill = artifacts.require("EWill");

contract("EWill", (accounts) => {
	const owner = accounts[0];
	const nominee = accounts[1];
	const MIN_BLOCK_BUFFER = 5;

	let ewill;
	beforeEach(async () => {
		ewill = await EWill.new(nominee, MIN_BLOCK_BUFFER);
	});

	describe("constructor", () => {
		it("should deploy", async () => {
			const wallet = await EWill.new(nominee, MIN_BLOCK_BUFFER);

			assert.equal(await EWill.owner(), owner);
		});
	});
});
