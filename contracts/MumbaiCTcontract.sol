// SPDX-License-Identifier: MIT

/*

    DEX COPY TRADING CONTRACT PROTOTYPE DEPLOYED ON MUMBAI POLYGON TESTNET
    DEV: PRAISE03

    ────────────────────────────────
    ───────────────██████████───────
    ──────────────████████████──────
    ──────────────██────────██──────
    ──────────────██▄▄▄▄▄▄▄▄▄█──────
    ──────────────██▀███─███▀█────── 
    █─────────────▀█────────█▀──────
    ██──────────────────█───────────
    ─█──────────────██──────────────
    █▄────────────████─██──████
    ─▄███████████████──██──██████ ──
    ────█████████████──██──█████████
    ─────────────████──██─█████──███
    ──────────────███──██─█████──███
    ──────────────███─────█████████
    ──────────────██─────████████▀
    ────────────────██████████
    ────────────────██████████
    ─────────────────████████
    ──────────────────██████████▄▄
    ────────────────────█████████▀
    ─────────────────────████──███
    ────────────────────▄████▄──██
    ────────────────────██████───▀
    ────────────────────▀▄▄▄▄▀
    

*/

pragma solidity ^0.8.0;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/interfaces/IQuoter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TransferHelper.sol";

//Uniswap Router Interface
interface IUniswapRouter is ISwapRouter {
    function refundETH() external payable;
}

struct Log {
    uint256 index; // Index of the log in the block
    uint256 timestamp; // Timestamp of the block containing the log
    bytes32 txHash; // Hash of the transaction containing the log
    uint256 blockNumber; // Number of the block containing the log
    bytes32 blockHash; // Hash of the block containing the log
    address source; // Address of the contract that emitted the log
    bytes32[] topics; // Indexed topics of the log
    bytes data; // Data of the log
}

//Chainlink Log Trigger automation inteface
interface ILogAutomation {
    function checkLog(
        Log calldata log,
        bytes memory checkData
    ) external returns (bool upkeepNeeded, bytes memory performData);

    function performUpkeep(bytes calldata performData) external;
}

contract CTMaticContract is ILogAutomation, Ownable {
    //ERRORS//
    error Zero_Amount();
    error Insufficient_Balance();
    error TransferFailed();

    //STATE VARIABLES//
    //Hardcoded UNISWAP and WMATIC Addresses since they're not liable to change anytime soon
    IUniswapRouter public constant uniswapRouter =
        IUniswapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    IQuoter public constant quoter =
        IQuoter(0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6);
    address private constant WMATIC =
        0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889;
    
    
    uint8 public subscriberCount;
    address[] subscribers;

    mapping(address subscriber => uint256 balance) public balances;

    //EVENTS
    event BuyOrder(
        address indexed tokenContractAddress,
        uint256 indexed amount,
        address recipient
    );
    event SellOrder(
        address indexed tokenContractAddress,
        uint256 indexed amount,
        address recipient
    );
    event logDisperce(
        uint256 swapAmount,
        uint256 receivedTokens,
        uint256 tokensToDistributePerUser,
        uint8 fundedSubscriberCount,
        address[] fundedSubscribers
    );

    //PUBLIC AND EXTERNAL FUNCTIONS

    //@notice: swap matic to token using uniswapv3
    //@dev: only callable by contract owner
    //@dev: emits buyOrder event which the chainlink keepers listen for
    function convertExactMaticToToken(
        address _tokenOut
    ) public payable onlyOwner {
        require(msg.value > 0, "Must pass non 0 MATIC amount");

        uint256 deadline = block.timestamp + 50; // using 'now' for convenience, for mainnet pass deadline from frontend!
        address tokenIn = WMATIC;
        address tokenOut = _tokenOut;
        uint24 fee = 3000;
        address recipient = msg.sender;
        uint256 amountIn = msg.value;
        uint256 amountOutMinimum = 1;
        uint160 sqrtPriceLimitX96 = 0;

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams(
                tokenIn,
                tokenOut,
                fee,
                recipient,
                deadline,
                amountIn,
                amountOutMinimum,
                sqrtPriceLimitX96
            );

        uniswapRouter.exactInputSingle{value: msg.value}(params);
        uniswapRouter.refundETH();

        //note should i?
        // if(msg.sender == owner) {
        //     emit()
        // }

        emit BuyOrder(_tokenOut, msg.value, msg.sender);
    }

    //@notice: swap function without emit event for copy trading
    function swapExactMaticToToken(address _tokenOut) public payable {
        require(msg.value > 0, "Must pass non 0 MATIC amount");

        uint256 deadline = block.timestamp + 50; // using 'now' for convenience, for mainnet pass deadline from frontend!
        address tokenIn = WMATIC;
        address tokenOut = _tokenOut;
        uint24 fee = 3000;
        address recipient = msg.sender;
        uint256 amountIn = msg.value;
        uint256 amountOutMinimum = 1;
        uint160 sqrtPriceLimitX96 = 0;

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams(
                tokenIn,
                tokenOut,
                fee,
                recipient,
                deadline,
                amountIn,
                amountOutMinimum,
                sqrtPriceLimitX96
            );

        uniswapRouter.exactInputSingle{value: msg.value}(params);
        uniswapRouter.refundETH();
    }

    //@notice: swaps token to Matic callable by contract owner only
    //@dev: emits sellOrder event for chainlink keeper automation
    function convertTokenToMatic(
        uint256 amountIn,
        address token
    ) public payable onlyOwner returns (uint256 amountOut) {
        require(amountIn > 0, "Cannot convert 0 Tokens");

        TransferHelper.safeTransferFrom(
            token,
            msg.sender,
            address(this),
            amountIn
        );

        TransferHelper.safeApprove(token, address(uniswapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: token,
                tokenOut: WMATIC,
                fee: 3000,
                recipient: msg.sender,
                deadline: block.timestamp + 100,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = uniswapRouter.exactInputSingle{value: 0}(params);
        emit SellOrder(token, amountIn, msg.sender);
    }

    //@notice: swaps token to Matic can be called by anyone
    function swapTokenToMatic(
        uint256 amountIn,
        address token
    ) public payable onlyOwner returns (uint256 amountOut) {
        require(amountIn > 0, "Cannot convert 0 Tokens");

        TransferHelper.safeTransferFrom(
            token,
            msg.sender,
            address(this),
            amountIn
        );

        TransferHelper.safeApprove(token, address(uniswapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: token,
                tokenOut: WMATIC,
                fee: 3000,
                recipient: msg.sender,
                deadline: block.timestamp + 100,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = uniswapRouter.exactInputSingle{value: 0}(params);
    }

    //@notice: Uniswap helper function to estimate tokens recieved from swap
    function estimateTokenForMatic(
        uint256 MaticAmount,
        address token
    ) external payable returns (uint256) {
        return
            quoter.quoteExactOutputSingle(token, WMATIC, 3000, MaticAmount, 0);
    }

    //@notice: Uniswap helper function to estimate tokens recieved from swap
    function estimateMaticforToken(
        uint256 tokenAmountOut,
        address token
    ) external payable returns (uint256) {
        return
            quoter.quoteExactOutputSingle(
                token,
                WMATIC,
                3000,
                tokenAmountOut,
                0
            );
    }

    //@chainlink: chainlink automation function, checked after every log event
    //@params: upkeepNeeded: returns true to indicate that upkeep is needed
    //@params: performData: data passed to the upkeep function
    function checkLog(
        Log calldata log,
        bytes memory
    ) external pure returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = true;
        address tokenContract = bytes32ToAddress(log.topics[1]);
        uint256 tokenAmount = bytes32ToUint256(log.topics[2]);
        performData = abi.encode(tokenContract, tokenAmount);
    }

    //@chainlink: upkeep function for dispersing tokens to subscribers
    //@notice: executed if checkLog returns true
    function performUpkeep(bytes calldata performData) external override {
        (address tokenAddress, uint256 amount) = abi.decode(
            performData,
            (address, uint256)
        );
        executeTradeAndDisperce(tokenAddress, amount);
    }

    //@dev: function to disperce tokens to subscribers after owner executes a swap
    function executeTradeAndDisperce(
        address tokenContractAddress,
        uint256 amount
    ) public payable {
        uint8 fundedSubscriberCount = getFundedSubscribersCount(amount);
        address[] memory fundedSubscribers = getFundedSubscriberAddresses(
            amount
        );

        uint256 swapAmount = amount * fundedSubscriberCount;

        uint256 balanceBefore = ERC20(tokenContractAddress).balanceOf(
            address(this)
        );
        swapFromContract(tokenContractAddress, amount);
        uint256 balanceAfter = ERC20(tokenContractAddress).balanceOf(
            address(this)
        );

        //token difference after swap execution
        uint256 receivedTokens = balanceAfter - balanceBefore;

        if (receivedTokens != 0) {
            uint256 tokenToDistributePerUser = receivedTokens /
                fundedSubscriberCount;
            //loop to disperce tokens to subscibers
            for (uint8 i; i < fundedSubscriberCount; i++) {
                bool success = ERC20(tokenContractAddress).transfer(
                    fundedSubscribers[i],
                    tokenToDistributePerUser
                );
                if (!success) revert TransferFailed();
                //remove amount used for swap from susbscriber's balance
                balances[fundedSubscribers[i]] -= amount;
            }

            emit logDisperce(
                swapAmount,
                receivedTokens,
                tokenToDistributePerUser,
                fundedSubscriberCount,
                fundedSubscribers
            );
        }
    }

    //@notice: subscribe to automatically copy owner's trades
    function subscribe() public payable {
        if (msg.value == 0) revert Zero_Amount();
        balances[msg.sender] += msg.value;

        subscriberCount += 1;
        subscribers.push(msg.sender);
    }

    //@notice: withdraw from deposited balance
    function withdraw(uint256 amount) public {
        if (amount > balances[msg.sender]) revert Insufficient_Balance();
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdraw Failed");
    }

    //INTERNAL FUNCTIONS

    //@dev: internal uniswapV3 swap function used only for token dispersion to subscribers
    function swapFromContract(
        address _tokenOut,
        uint256 amount
    ) internal returns (uint256 receivedTokens) {
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams(
                WMATIC,
                _tokenOut,
                3000,
                address(this),
                block.timestamp + 50,
                amount,
                1,
                0
            );
        receivedTokens = uniswapRouter.exactInputSingle{value: amount}(params);
        uniswapRouter.refundETH();
        return receivedTokens;
    }

    //VIEW FUNCTIONS

    // @notice: Retrieve number of adequately funded subscribers before executing a particular trade
    //@params: requiredBalance: minimum amount that must have been deposited to be considered adequately funded
    function getFundedSubscribersCount(
        uint256 requiredBalance
    ) private view returns (uint8 fundedSubscriberCount) {
        fundedSubscriberCount = subscriberCount;
        for (uint8 i; i < subscriberCount; i++) {
            if (balances[subscribers[i]] < requiredBalance) {
                fundedSubscriberCount -= 1;
            }
        }
    }

    //@notice: returns address of adequately funded subscribers for distributing tokens
    //@params: requiredBalance: minimum amount that must have been deposited to be considered adequately funded
    function getFundedSubscriberAddresses(
        uint256 requiredBalance
    ) private view returns (address[] memory fundedSubscribers) {
        fundedSubscribers = new address[](
            getFundedSubscribersCount(requiredBalance)
        );
        for (uint8 i; i < subscribers.length; i++) {
            if (balances[subscribers[i]] >= requiredBalance) {
                fundedSubscribers[i] = subscribers[i];
            }
        }
    }

    //@returns: users deposited balance
    function userBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    //PURE FUNCTIONS
    //@dev: helper function to convert log performData params to required type
    function bytes32ToAddress(bytes32 _address) public pure returns (address) {
        return address(uint160(uint256(_address)));
    }

    function bytes32ToUint256(bytes32 _amount) public pure returns (uint256) {
        return uint256(_amount);
    }

    // allows contract to receive ETH
    receive() external payable {}
}
