const HDWalletProvider = require("truffle-hdwallet-provider");
const memonic = "...";

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            from: "0xCf0F482F2C1eF1f221f09e3Cf14122fcE0424F94",
            port: 4444,
            network_id: "*" // Match any network id
        },
        rsk: {
            host: "localhost",
            port: 4444,
            gas : 60000000,
            gasPrice : 2,
            network_id: "*",
            from: "0xCf0F482F2C1eF1f221f09e3Cf14122fcE0424F94"
        },
	rsklive: {
		provider: function() {
        		return new HDWalletProvider(memonic, "http://localhost:4444")
      		},
		gas : 68000000,
		gasPrice : 1,
		network_id: "*",
		//from: "0x5b556607aa00592385c3b2481210bb2703b0be96"

	}
    }
};
