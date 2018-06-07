module.exports = {
    // See <http://truffleframework.com/docs/advanced/configuration>
    // to customize your Truffle configuration!
    networks: {
        development: {
            host: "127.0.0.1",
            //from: "0x00E9ecF2C0e35Ba6392e29D0C82fFBe33B3B1C6C",
            port: 7545,
            network_id: "*" // Match any network id
        }
    }
};
