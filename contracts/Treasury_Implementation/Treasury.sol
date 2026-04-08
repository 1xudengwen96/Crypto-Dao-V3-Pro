// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";



interface IBondCalculator {
    function valuation(address _pool, uint256 _amount) external view returns (uint256 _value);
}

interface IProToken {
    function mint(address _to, uint256 _amount) external;
}

interface IERC20Token {
    function transfer(address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
}


contract CryptoTreasury is OwnableUpgradeable {
    using SafeERC20 for IERC20;

    enum MANAGING {
        RESERVEDEPOSITOR,
        RESERVESPENDER,
        RESERVETOKEN,
        RESERVEMANAGER,
        LIQUIDITYDEPOSITOR,
        LIQUIDITYTOKEN,
        LIQUIDITYMANAGER,
        REWARDMANAGER
    }


    uint public  blocksNeededForQueue;

    address[] public reserveTokens; // Push only, beware false-positives.
    mapping(address => bool) public isReserveToken;
    mapping(address => uint) public reserveTokenQueue; // Delays changes to mapping.

    address[] public reserveDepositors; // Push only, beware false-positives. Only for viewing.
    mapping(address => bool) public isReserveDepositor;
    mapping(address => uint) public reserveDepositorQueue; // Delays changes to mapping.

    address[] public reserveSpenders; // Push only, beware false-positives. Only for viewing.
    mapping(address => bool) public isReserveSpender;
    mapping(address => uint) public reserveSpenderQueue; // Delays changes to mapping.

    address[] public liquidityTokens; // Push only, beware false-positives.
    mapping(address => bool) public isLiquidityToken;
    mapping(address => uint) public LiquidityTokenQueue; // Delays changes to mapping.

    address[] public liquidityDepositors; // Push only, beware false-positives. Only for viewing.
    mapping(address => bool) public isLiquidityDepositor;
    mapping(address => uint) public LiquidityDepositorQueue; // Delays changes to mapping.

    mapping(address => address) public bondCalculator; // bond calculator for liquidity token

    address[] public reserveManagers; // Push only, beware false-positives. Only for viewing.
    mapping(address => bool) public isReserveManager;
    mapping(address => uint) public ReserveManagerQueue; // Delays changes to mapping.

    address[] public liquidityManagers; // Push only, beware false-positives. Only for viewing.
    mapping(address => bool) public isLiquidityManager;
    mapping(address => uint) public LiquidityManagerQueue; // Delays changes to mapping.


    address[] public rewardManagers; // Push only, beware false-positives. Only for viewing.
    mapping(address => bool) public isRewardManager;
    mapping(address => uint) public rewardManagerQueue; // Delays changes to mapping.

    uint public totalReserves; // Risk-free value of all assets

    address public proToken;
    address public dead;
    address public rbs;
    address public usd;


    event DepositStableReserve(address indexed token, uint amount, uint value);
    event DepositBondReserve(address indexed token, uint amount, uint value);
    event ReservesManaged(address indexed token, uint amount);
    event ReservesUpdated(uint indexed totalReserves);
    event ReservesAudited(uint indexed totalReserves);
    event RewardsMinted(
        address indexed caller,
        address indexed recipient,
        uint amount
    );
    event ChangeQueued(MANAGING indexed managing, address queued);
    event ChangeActivated(
        MANAGING indexed managing,
        address activated,
        bool result
    );


    function initialize (address _token, address _usd, address _pool, address _calu) public initializer {
        require(_token != address(0));
        __Ownable_init(msg.sender);

        usd = _usd;
        proToken = _token;
        isReserveToken[_usd] = true;
        reserveTokens.push(_usd);

        isLiquidityToken[_pool] = true;
        liquidityTokens.push(_pool);
        bondCalculator[_pool] = _calu;

        blocksNeededForQueue = 1;

        dead = 0x000000000000000000000000000000000000dEaD;
    }

    /**
     * @dev Modifier to restrict function access to rbs only
     */
    modifier onlyUnauthorized() {
        require(msg.sender == rbs || isReserveDepositor[msg.sender], "unauthorized access");
        _;
    }

    function setRbsContract(address _rbs) external onlyOwner {
        require(_rbs != address(0), "invalid rbs");
        rbs = _rbs;
    }


    function depositStableReserve(address _token, uint256 _amount, uint256 _profit) external onlyUnauthorized returns (uint256 send) {
        require(isReserveToken[_token], "Not accepted");

        IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);

        uint value = valueOf(_token, _amount);
        // transfer OHM needed and store amount of rewards for distribution
        send = value -_profit;
        if (send > 0) {
            _permissionMint(msg.sender, send);
        }

        totalReserves = totalReserves + value;
        emit ReservesUpdated(totalReserves);

        emit DepositStableReserve(_token, _amount, value);
    }


    function depositBondReserve(address _token, uint256 _amount, uint256 _profit) external returns (uint256 send) {
        require(isLiquidityToken[_token] && isLiquidityDepositor[msg.sender], "Not approved");

        IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
        IERC20(_token).safeTransfer(dead, _amount);

        uint value = valueOf(_token, _amount);
        // transfer OHM needed and store amount of rewards for distribution
        send = value -_profit;
        if (send > 0) {
            _permissionMint(msg.sender, send);
        }

        totalReserves = totalReserves + value;
        emit ReservesUpdated(totalReserves);

        emit DepositBondReserve(_token, _amount, value);
    }



    function _permissionMint(address receiver, uint amount) internal {
        IProToken(proToken).mint(receiver, amount);
    }

    function supplied() public view returns (uint) {
        return IERC20(proToken).totalSupply();
    }

    /**
        @notice allow approved address to withdraw assets, include reserves and liquidity tokens
        @param _token address
        @param _amount uint
     */
    function manage(address _token, uint _amount) external {
        if (isLiquidityToken[_token]) {
            require(isLiquidityManager[msg.sender], "Not approved");
        } else {
            require(isReserveManager[msg.sender], "Not approved");
        }

        uint value = valueOf(_token, _amount);
        require(value <= excessReserves(), "Insufficient reserves");

        totalReserves = totalReserves - value;
        emit ReservesUpdated(totalReserves);

        IERC20(_token).safeTransfer(msg.sender, _amount);

        emit ReservesManaged(_token, _amount);
    }

    /**
        @notice send epoch reward to staking contract
     */
    function mintRewards(address _recipient, uint _amount) external {
        require(isRewardManager[msg.sender], "Not approved");
        require(_amount <= excessReserves(), "Insufficient reserves");

        _permissionMint(_recipient, _amount);
        emit RewardsMinted(msg.sender, _recipient, _amount);
    }

    /**
        @notice returns excess reserves not backing tokens
        @return uint
     */
    function excessReserves() public view returns (uint) {
        uint result = totalReserves - supplied();
        return result;
    }

    /**
        @notice takes inventory of all tracked assets
        @notice always consolidate to recognized reserves before audit
     */
    function auditReserves() external onlyOwner {
        uint reserves;
        for (uint i = 0; i < reserveTokens.length; i++) {
            reserves = reserves +
                valueOf(
                    reserveTokens[i],
                    IERC20(reserveTokens[i]).balanceOf(address(this))
                )
            ;
        }
        for (uint i = 0; i < liquidityTokens.length; i++) {
            reserves = reserves +
                valueOf(
                    liquidityTokens[i],
                    IERC20(liquidityTokens[i]).balanceOf(address(this))
                )
            ;
        }
        totalReserves = reserves;
        emit ReservesUpdated(reserves);
        emit ReservesAudited(reserves);
    }

    /**
        @notice returns OHM valuation of asset
        @param _token address
        @param _amount uint
        @return value_ uint
     */
    function valueOf(
        address _token,
        uint _amount
    ) public view returns (uint value_) {
        if (isReserveToken[_token]) {
            // convert amount to match OHM decimals
            value_ = _amount * (10 ** IERC20Token(proToken).decimals()) / (
                10 ** IERC20Token(_token).decimals()
            );
        } else if (isLiquidityToken[_token]) {
            value_ = IBondCalculator(bondCalculator[_token]).valuation(
                _token,
                _amount
            );
        }
    }

    /**
        @notice queue address to change boolean in mapping
        @param _managing MANAGING
        @param _address address
        @return bool
     */
    function queue(
        MANAGING _managing,
        address _address
    ) external onlyOwner returns (bool) {
        require(_address != address(0));
        if (_managing == MANAGING.RESERVEDEPOSITOR) {
            // 0
            reserveDepositorQueue[_address] = block.number + blocksNeededForQueue;
        } else if (_managing == MANAGING.RESERVESPENDER) {
            // 1
            reserveSpenderQueue[_address] = block.number + blocksNeededForQueue;
        } else if (_managing == MANAGING.RESERVETOKEN) {
            // 2
            reserveTokenQueue[_address] =block.number + blocksNeededForQueue;
        } else if (_managing == MANAGING.RESERVEMANAGER) {
            // 3
            ReserveManagerQueue[_address] = block.number + blocksNeededForQueue;
        } else if (_managing == MANAGING.LIQUIDITYDEPOSITOR) {
            // 4
            LiquidityDepositorQueue[_address] = block.number + blocksNeededForQueue;
        } else if (_managing == MANAGING.LIQUIDITYTOKEN) {
            // 5
            LiquidityTokenQueue[_address] = block.number + blocksNeededForQueue;
        } else if (_managing == MANAGING.LIQUIDITYMANAGER) {
            // 6
            LiquidityManagerQueue[_address] = block.number + blocksNeededForQueue;
        } else if (_managing == MANAGING.REWARDMANAGER) {
            // 7
            rewardManagerQueue[_address] = block.number + blocksNeededForQueue;
        } else return false;

        emit ChangeQueued(_managing, _address);
        return true;
    }

    /**
        @notice verify queue then set boolean in mapping
        @param _managing MANAGING
        @param _address address
        @param _calculator address
        @return bool
     */
    function toggle(
        MANAGING _managing,
        address _address,
        address _calculator
    ) external onlyOwner returns (bool) {
        require(_address != address(0));
        bool result;
        if (_managing == MANAGING.RESERVEDEPOSITOR) {
            // 0
            if (requirements(reserveDepositorQueue, isReserveDepositor,_address)) {
                reserveDepositorQueue[_address] = 0;
                if (!listContains(reserveDepositors, _address)) {
                    reserveDepositors.push(_address);
                }
            }
            result = !isReserveDepositor[_address];
            isReserveDepositor[_address] = result;
        } else if (_managing == MANAGING.RESERVESPENDER) {
            // 1
            if (requirements(reserveSpenderQueue, isReserveSpender, _address)) {
                reserveSpenderQueue[_address] = 0;
                if (!listContains(reserveSpenders, _address)) {
                    reserveSpenders.push(_address);
                }
            }
            result = !isReserveSpender[_address];
            isReserveSpender[_address] = result;
        } else if (_managing == MANAGING.RESERVETOKEN) {
            // 2
            if (requirements(reserveTokenQueue, isReserveToken, _address)) {
                reserveTokenQueue[_address] = 0;
                if (!listContains(reserveTokens, _address)) {
                    reserveTokens.push(_address);
                }
            }
            result = !isReserveToken[_address];
            isReserveToken[_address] = result;
        } else if (_managing == MANAGING.RESERVEMANAGER) {
            // 3
            if (requirements(ReserveManagerQueue, isReserveManager, _address)) {
                ReserveManagerQueue[_address] = 0;
                if (!listContains(reserveManagers, _address)) {
                    reserveManagers.push(_address);
                }
            }
            result = !isReserveManager[_address];
            isReserveManager[_address] = result;
        } else if (_managing == MANAGING.LIQUIDITYDEPOSITOR) {
            // 4
            if (requirements(LiquidityDepositorQueue,isLiquidityDepositor,_address)) {
                LiquidityDepositorQueue[_address] = 0;
                if (!listContains(liquidityDepositors, _address)) {
                    liquidityDepositors.push(_address);
                }
            }
            result = !isLiquidityDepositor[_address];
            isLiquidityDepositor[_address] = result;
        } else if (_managing == MANAGING.LIQUIDITYTOKEN) {
            // 5
            if (requirements(LiquidityTokenQueue, isLiquidityToken, _address)) {
                LiquidityTokenQueue[_address] = 0;
                if (!listContains(liquidityTokens, _address)) {
                    liquidityTokens.push(_address);
                }
            }
            result = !isLiquidityToken[_address];
            isLiquidityToken[_address] = result;
            bondCalculator[_address] = _calculator;
        } else if (_managing == MANAGING.LIQUIDITYMANAGER) {
            // 6
            if (requirements(LiquidityManagerQueue,isLiquidityManager,_address)) {
                LiquidityManagerQueue[_address] = 0;
                if (!listContains(liquidityManagers, _address)) {
                    liquidityManagers.push(_address);
                }
            }
            result = !isLiquidityManager[_address];
            isLiquidityManager[_address] = result;
        } else if (_managing == MANAGING.REWARDMANAGER) {
            // 7
            if (requirements(rewardManagerQueue, isRewardManager, _address)) {
                rewardManagerQueue[_address] = 0;
                if (!listContains(rewardManagers, _address)) {
                    rewardManagers.push(_address);
                }
            }
            result = !isRewardManager[_address];
            isRewardManager[_address] = result;
        } else return false;

        emit ChangeActivated(_managing, _address, result);
        return true;
    }

    /**
        @notice checks requirements and returns altered structs
        @param queue_ mapping( address => uint )
        @param status_ mapping( address => bool )
        @param _address address
        @return bool
     */
    function requirements(
        mapping(address => uint) storage queue_,
        mapping(address => bool) storage status_,
        address _address
    ) internal view returns (bool) {
        if (!status_[_address]) {
            require(queue_[_address] != 0, "Must queue");
            require(queue_[_address] <= block.number, "Queue not expired");
            return true;
        }
        return false;
    }

    /**
        @notice checks array to ensure against duplicate
        @param _list address[]
        @param _token address
        @return bool
     */
    function listContains(
        address[] storage _list,
        address _token
    ) internal view returns (bool) {
        for (uint i = 0; i < _list.length; i++) {
            if (_list[i] == _token) {
                return true;
            }
        }
        return false;
    }
}