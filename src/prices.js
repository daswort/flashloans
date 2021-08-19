const request = require("async-request");

module.exports.getPrices = async () => {
    const response = await request('https://api.coingecko.com/api/v3/simple/price?ids=binancecoin,ethereum,bitcoin,tether,usd-coin,busd,mist,cryptoblades,axie-infinity&vs_currencies=usd');
    const prices = {};

    try {
        const json = JSON.parse(response.body);
        //console.log(json)
        prices['0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c'.toLowerCase()] = json.binancecoin.usd;
        prices['0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56'.toLowerCase()] = json.busd.usd;
        prices['0x2170Ed0880ac9A755fd29B2688956BD959F933F8'.toLowerCase()] = json.ethereum.usd;
        prices['0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c'.toLowerCase()] = json.bitcoin.usd;
        prices['0x55d398326f99059ff775485246999027b3197955'.toLowerCase()] = json.tether.usd;
        prices['0x68E374F856bF25468D365E539b700b648Bf94B67'.toLowerCase()] = json.mist.usd;
        prices['0x154A9F9cbd3449AD22FDaE23044319D6eF2a1Fab'.toLowerCase()] = json.cryptoblades.usd;
        prices['0x715D400F88C167884bbCc41C5FeA407ed4D2f8A0'.toLowerCase()] = json['axie-infinity'].usd;
        // prices['??'.toLowerCase()] = json['usd-coin'].usd;
    } catch (e) {
        console.error(e)
        return {};
    }

    return prices;
}
