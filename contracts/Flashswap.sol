// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.6 <0.8.0;

import './interfaces/IUniswapV2Router.sol';
import './interfaces/IUniswapV2Pair.sol';
import './interfaces/IUniswapV2Factory.sol';
import './interfaces/IERC20.sol';

// @author pndrgn
//
// aa: Muy lento, el bloque ya paso
// bb: Muy lento, ya no hay ganancia
// cc: El par no existe
// dd: Token0 o token1 no existe
// ee: src/target router vacio
// ff: pancakeCall No hay suficientes tokens para recomprar
// gg: pancakeCall La transaccion del msg.sender fallo
// hh: pancakeCall La transferencia de propiedad fallo
contract Flashswap {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function start(
        uint _maxBlockNumber,
        address _tokenBorrow,
        uint256 _amountTokenPay,
        address _tokenPay,
        address _sourceRouter,
        address _targetRouter,
        address _sourceFactory
    ) external {
        require(block.number <= _maxBlockNumber, 'aa');

        // se rechequea los montos y el gas a usar
        (int256 profit, uint256 _tokenBorrowAmount) = check(_tokenBorrow, _amountTokenPay, _tokenPay, _sourceRouter, _targetRouter);
        require(profit > 0, 'bb');

        address pairAddress = IUniswapV2Factory(_sourceFactory).getPair(_tokenBorrow, _tokenPay);
        require(pairAddress != address(0), 'cc');

        address token0 = IUniswapV2Pair(pairAddress).token0();
        address token1 = IUniswapV2Pair(pairAddress).token1();

        require(token0 != address(0) && token1 != address(0), 'dd');

        IUniswapV2Pair(pairAddress).swap(
            _tokenBorrow == token0 ? _tokenBorrowAmount : 0,
            _tokenBorrow == token1 ? _tokenBorrowAmount : 0,
            address(this),
            abi.encode(_sourceRouter, _targetRouter)
        );
    }

    function check(
        address _tokenBorrow,
        uint256 _amountTokenPay,
        address _tokenPay,
        address _sourceRouter,
        address _targetRouter
    ) public view returns(int256, uint256) {
        address[] memory path1 = new address[](2);
        address[] memory path2 = new address[](2);
        path1[0] = path2[1] = _tokenPay;
        path1[1] = path2[0] = _tokenBorrow;

        uint256 amountOut = IUniswapV2Router(_sourceRouter).getAmountsOut(_amountTokenPay, path1)[1];
        uint256 amountRepay = IUniswapV2Router(_targetRouter).getAmountsOut(amountOut, path2)[1];

        return (
            int256(amountRepay - _amountTokenPay), // nuestra ganancia o perdida
            amountOut // el monto que obtendremos del input _amountTokenPay
        );
    }

    function execute(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) internal {
        // obtain an amount of token that you exchanged
        // obtiene un monto del token que intercambiaste
        uint256 amountToken = _amount0 == 0 ? _amount1 : _amount0;

        IUniswapV2Pair iUniswapV2Pair = IUniswapV2Pair(msg.sender);
        address token0 = iUniswapV2Pair.token0();
        address token1 = iUniswapV2Pair.token1();

        // si _amount0 es cero, se vende token1 por token0
        // sino se vende token0 for token1 como resultado
        address[] memory path1 = new address[](2);
        address[] memory path = new address[](2);
        path[0] = path1[1] = _amount0 == 0 ? token1 : token0; // c&p
        path[1] = path1[0] = _amount0 == 0 ? token0 : token1; // c&p

        (address sourceRouter, address targetRouter) = abi.decode(_data, (address, address));
        require(sourceRouter != address(0) && targetRouter != address(0), 'ee');

        // IERC20 token que venderemos por otherToken
        IERC20 token = IERC20(_amount0 == 0 ? token1 : token0);
        token.approve(targetRouter, amountToken);

        // se calcula el monto de tokens que debe ser reembolsado
        uint256 amountRequired = IUniswapV2Router(sourceRouter).getAmountsIn(amountToken, path1)[0];

        // se intercambia el token y se obtiene como resultado el equivalente en otherToken
        uint256 amountReceived = IUniswapV2Router(targetRouter).swapExactTokensForTokens(
            amountToken,
            amountRequired, // ya tenemos lo que necesitamos al menos para recomprar, obtener menos no funcionara. Slippage puede calcularse así ((amountRequired * 19) / 981) + 1
            path,
            address(this), // es una invocacion desde el router pero necesitamos la direccion del contrato sea igual a la del _sender
            block.timestamp + 60
        )[1];

        // falla si no obtenemos los tokens suficientes
        require(amountReceived > amountRequired, 'ff');

        IERC20 otherToken = IERC20(_amount0 == 0 ? token0 : token1);

        // la transferencia fallida ya viene con un mensaje de error
        otherToken.transfer(msg.sender, amountRequired); // se devuelve el prestamo
        otherToken.transfer(owner, amountReceived - amountRequired); // nuestra ganacia
    }

    // pancake, pancakeV2, apeswap, kebab
    function pancakeCall(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        execute(_sender, _amount0, _amount1, _data);
    }

    function waultSwapCall(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        execute(_sender, _amount0, _amount1, _data);
    }

    function uniswapV2Call(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        execute(_sender, _amount0, _amount1, _data);
    }

    // mdex
    function swapV2Call(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        execute(_sender, _amount0, _amount1, _data);
    }

    // pantherswap
    function pantherCall(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        execute(_sender, _amount0, _amount1, _data);
    }

    // jetswap
    function jetswapCall(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        execute(_sender, _amount0, _amount1, _data);
    }

    // cafeswap
    function cafeCall(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        execute(_sender, _amount0, _amount1, _data);
    }

    // @TODO
    function BiswapCall(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        execute(_sender, _amount0, _amount1, _data);
    }

    // @TODO
    function wardenCall(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        execute(_sender, _amount0, _amount1, _data);
    }
}
