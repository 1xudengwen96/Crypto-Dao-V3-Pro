// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {OwnableUpgradeable} from  "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library Babylonian {
    function sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;

        uint256 xx = x;
        uint256 r = 1;
        if (xx >= 0x100000000000000000000000000000000) {
            xx >>= 128;
            r <<= 64;
        }
        if (xx >= 0x10000000000000000) {
            xx >>= 64;
            r <<= 32;
        }
        if (xx >= 0x100000000) {
            xx >>= 32;
            r <<= 16;
        }
        if (xx >= 0x100) {
            xx >>= 16;
            r <<= 8;
        }
        if (xx >= 0x10) {
            xx >>= 8;
            r <<= 4;
        }
        if (xx >= 0x8) {
            r <<= 1;
        }
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1; // Seven iterations should be enough
        uint256 r1 = x / r;
        return (r < r1 ? r : r1);
    }
}


interface IPancakeRouter {
    function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint[] memory amounts);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function addLiquidity(
        address tokenA, address tokenB, uint amountADesired, uint amountBDesired,
        uint amountAMin, uint amountBMin, address to, uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
}

interface IPancakePair {
    function getReserves() external view returns (uint112, uint112, uint32);
    function token0() external view returns (address);
    function token1() external view returns (address);
}

interface ITreasury {
    function deposit(uint256 _usdAmount, uint256 _mintAmount) external returns (uint256);
    function depositStableReserve(address _token, uint256 _amount, uint256 _profit) external returns (uint256);
}


contract RBSControl is OwnableUpgradeable {
    using SafeERC20 for IERC20;

    IPancakeRouter public swapRouter;
    IPancakePair public pair;

    address public treasury;
    address public usd;
    uint256 public lastMintTimes;

    event Minted(address indexed _send, uint256 _amount);
    event Burned(address indexed _to, uint256 _amount);


    function initialize(address _owner, address _router, address _pool, address _treasury, address _usd) external initializer {
        __Ownable_init(_owner);

        swapRouter = IPancakeRouter(_router);
        pair = IPancakePair(_pool);

        treasury = _treasury;
        usd = _usd;
    }

    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts){
        return swapRouter.getAmountsIn(amountOut, path);
    }

    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts){
        return swapRouter.getAmountsOut(amountIn, path);
    }


    function getTokenPrice(address _token) public view returns (uint256 price) {
        (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();
        address token0 = pair.token0();
        if (token0 == _token) {
            // price = reserve0 / reserve1
            price = uint256(reserve0) / uint256(reserve1);
        } else {
            // price = reserve1 / reserve0
            price = uint256(reserve1) / uint256(reserve0);
        }
    }

    function getAmountForPair(address _pair, address _token, uint256 _amountIn) external view returns (uint256 amount) {
        (uint112 reserve0, uint112 reserve1, ) = IPancakePair(_pair).getReserves();
        address token0 = IPancakePair(_pair).token0();
        if (token0 == _token) {
            amount =  _amountIn *  uint256(reserve1) /  uint256(reserve0);
        } else {
            amount =  _amountIn *  uint256(reserve0) /  uint256(reserve1);
            
        }
    }


    function estimateLiquidityAmount(uint256 _amount0, uint256 _amount1) external view returns (uint256 _lpAmount, uint256 _totalSupply) {
        (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();

        _totalSupply = IERC20(address(pair)).totalSupply();
        _lpAmount = calculateLiquidityAmount(_amount0, _amount1, reserve0, reserve1, _totalSupply);

        return (_lpAmount, _totalSupply);
    }

     function estimateLiquidityAmountForPair(address _pair,uint256 _amount0, uint256 _amount1) external view returns (uint256 _lpAmount, uint256 _totalSupply) {
        (uint112 reserve0, uint112 reserve1, ) = IPancakePair(_pair).getReserves();

        _totalSupply = IERC20(_pair).totalSupply();
        _lpAmount = calculateLiquidityAmount(_amount0, _amount1, reserve0, reserve1, _totalSupply);

        return (_lpAmount, _totalSupply);
    }

    function quote(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256) {
        require(amountIn > 0, "Insufficient input amount");
        require(reserveIn > 0 && reserveOut > 0, "Insufficient liquidity");
        return amountIn * reserveOut / reserveIn;
    }


    function calculateLiquidityAmount(uint256 amount0, uint256 amount1, uint256 reserve0, uint256 reserve1, uint256 totalSupply) public pure returns (uint256) {
        if (totalSupply == 0) {
            return Babylonian.sqrt(amount0 * amount1) - 1000;
        } else {
            uint256 amount0Optimal = quote(amount1, reserve1, reserve0);
            if (amount0Optimal <= amount0) {
                require(amount0Optimal >= 1, "Insufficient liquidity for mint");
                return amount1 * totalSupply / reserve1;
            } else {
                uint256 amount1Optimal = quote(amount0, reserve0, reserve1);
                assert(amount1Optimal <= amount1);
                require(amount1Optimal >= 1, "Insufficient liquidity for mint");
                return amount0 * totalSupply / reserve0;
            }
        }
    }



    function swap(address[] calldata _path, uint256 _amountIn, uint256 _amountOutMin, uint256 _deadline) external onlyOwner {
        require(_amountIn <= IERC20(_path[0]).balanceOf(address(this)), "Insufficient balance");

        IERC20(_path[0]).safeIncreaseAllowance(address(swapRouter), _amountIn);
        swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(_amountIn, _amountOutMin, _path, address(this), _deadline);
    }



    function addLiquidity(address tokenA, address tokenB,  uint256 amountAIn, uint256 amountBIn, uint256 _deadline) external onlyOwner returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
        require(amountAIn <= IERC20(tokenA).balanceOf(address(this)) &&  amountBIn <= IERC20(tokenB).balanceOf(address(this)), "Insufficient balance");
        
        IERC20(tokenA).safeIncreaseAllowance(address(swapRouter), amountAIn);
        IERC20(tokenB).safeIncreaseAllowance(address(swapRouter), amountBIn);

        (amountA, amountB, liquidity) = swapRouter.addLiquidity(tokenA, tokenB, amountAIn, amountBIn, amountAIn*95/100, amountBIn*95/100, address(this), _deadline);
    }
    

    function burnLP() external onlyOwner {
        uint256 lpAmount =  IERC20(address(pair)).balanceOf(address(this));
        IERC20(address(pair)).safeTransfer(0x000000000000000000000000000000000000dEaD, lpAmount);

        emit Burned(address(this), lpAmount);
    }

    
    function mint(uint256 _usdAmount, uint256 _profitAmount) external onlyOwner {
        require(_usdAmount <= IERC20(usd).balanceOf(address(this)), "Insufficient balance");
        require(lastMintTimes == 0 || block.timestamp > lastMintTimes + 30 minutes, "invalid times");
        require(_usdAmount <= 200_000 * 1e18, "max balance");
        require( IERC20( 0x8D65744527f55d0b2338350912d5C99A81ddF0e2 ).balanceOf(address(this)) < 20_000 * 1e9, "Unauthorized");

        lastMintTimes = block.timestamp;

        //approve treasury
        IERC20(usd).safeIncreaseAllowance(treasury, _usdAmount);
        uint256 mintAmount = ITreasury(treasury).depositStableReserve(usd, _usdAmount, _profitAmount);

        emit Minted(msg.sender, mintAmount);
    }

   
}
