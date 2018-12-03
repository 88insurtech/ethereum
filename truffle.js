module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            //from: "0x00E9ecF2C0e35Ba6392e29D0C82fFBe33B3B1C6C",
            port: 9545,
            network_id: "*" // Match any network id
        },
        rsk: {
            host: "m.rsk.alebanzas.com.ar",
            port: 4444,
            gas : 2500000,
            gasPrice : 1,
            network_id: "*",
            from: "0xCf0F482F2C1eF1f221f09e3Cf14122fcE0424F94"
        }
    }
};
