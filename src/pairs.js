const pancake = {
    router: "0x10ed43c718714eb63d5aa57b78b54704e256024e",
    factory: "0xca143ce32fe78f1f7019d7d551a6402fc5350c73",
    routerV1: "0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F",
    factoryV1: "0xBCfCcbde45cE874adCB698cC183deBcF17952812"
};

const panther = {
    router: "0xbe65b8f75b9f20f4c522e0067a3887fada714800",
    factory: "0x0eb58e5c8aa63314ff5547289185cc4583dfcbd5"
};

const ape = {
    router: "0xcF0feBd3f17CEf5b47b0cD257aCf6025c5BFf3b7",
    factory: "0x0841BD0B734E4F5853f0dD8d7Ea041c241fb0Da6"
};

const biswap = {
    router: "0x3a6d8cA21D1CF76F653A67577FA0D27453350dD8",
    factory: "0x858E3312ed3A876947EA49d572A7C42DE08af7EE"
};

const bakery = {
    router: "0xCDe540d7eAFE93aC5fE6233Bee57E1270D3E330F",
    factory: "0x01bF7C66c6BD861915CdaaE475042d3c4BaE16A7"
}

const cafe = {
    router: "0x933DAea3a5995Fb94b14A7696a5F3ffD7B1E385A",
    factory: "0x3e708FdbE3ADA63fc94F8F61811196f1302137AD"
}


module.exports.getPairs = () => {

    const BNB_MAINNET = '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c';
    const BUSD_MAINNET = '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56';
    const MIST_MAINNET = '0x68E374F856bF25468D365E539b700b648Bf94B67';
    const CYT_MAINNET = '0xd9025e25Bb6cF39f8c926A704039D2DD51088063';
    const SKILL_MAINNET = '0x154A9F9cbd3449AD22FDaE23044319D6eF2a1Fab';
    const AXS_MAINNET = '0x715D400F88C167884bbCc41C5FeA407ed4D2f8A0';

    const pairs = [
        {
            name: 'BNB/MIST pancake>cafe',
            tokenBorrow: BNB_MAINNET,
            amountTokenPay: 1000,
            tokenPay: MIST_MAINNET,
            sourceRouter: pancake.router,
            targetRouter: cafe.router,
            sourceFactory: pancake.factory
        },
        {
            name: 'BNB/MIST cafe>pancake',
            tokenBorrow: BNB_MAINNET,
            amountTokenPay: 1000,
            tokenPay: MIST_MAINNET,
            sourceRouter: cafe.router,
            targetRouter: pancake.router,
            sourceFactory: cafe.factory
        },
        {
            name: 'BNB/SKILL ape>pancake',
            tokenBorrow: BNB_MAINNET,
            amountTokenPay: 1000,
            tokenPay: SKILL_MAINNET,
            sourceRouter: ape.router,
            targetRouter: pancake.router,
            sourceFactory: ape.factory
        },
        {
            name: 'BNB/SKILL pancake>ape',
            tokenBorrow: BNB_MAINNET,
            amountTokenPay: 1000,
            tokenPay: SKILL_MAINNET,
            sourceRouter: pancake.router,
            targetRouter: ape.router,
            sourceFactory: pancake.factory
        },
        {
            name: 'BNB/AXS ape>pancake',
            tokenBorrow: BNB_MAINNET,
            amountTokenPay: 1000,
            tokenPay: AXS_MAINNET,
            sourceRouter: ape.router,
            targetRouter: pancake.router,
            sourceFactory: ape.factory
        },
        {
            name: 'BNB/AXS pancake>ape',
            tokenBorrow: BNB_MAINNET,
            amountTokenPay: 1000,
            tokenPay: AXS_MAINNET,
            sourceRouter: pancake.router,
            targetRouter: ape.router,
            sourceFactory: pancake.factory
        }

    ]

    return pairs
}
