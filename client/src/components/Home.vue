<template>
  <div class="">
  
      <div class="backdrop-blur-xl">
          <h1 class="ml-auto mr-auto text-2xl font-bold text-center p-8 uppercase tracking-[0.3em]">A DEX Copy Trading Prototype</h1>
  
          <div class="center">
              <img class="w-72 h-72 ml-auto mr-auto" src="/91.png" alt="">
          </div>

          <div class="text-white justify-center capitalize text-lg font-thin text-center">
            <h1 class="font-extrabold text-2xl">How It Works.</h1>
            <p>1. Trader Deploys Copy Trading Contract and connects it to the website UI</p>
            <p>2. Using the mock UniswapV3 Interface the trader can execute token buys/sells</p>
            <p>3. In the UI specific to that trader, Users can "subscribe" to the Traders trades</p>
            <p>4. Subscribing denotes depositing any amount of MATIC into the copy trading contract</p>
            <p>5. After Subscribing, the contract the automatically replicates the Trader's exact token trades on behalf of the subscriber
              and sends the received tokens to the subscribers wallet.
            </p>
            <p>6. The automation above is done by listening to emitted event logs from the contract After the trader performs swaps and recreating the
              swap using the same swap parameters, this is done using chainlink Log Trigger Automations </p>
            <p>7. For users who would rather choose what trades they'd like to copy on their own, a log of all the Trader's trades is also stored,
              and can be easily copied by clicking the <span class="font-extrabold text-lg">COPY</span> button besides every trade log.
            </p>

            </div>
      </div>
      
      
  </div>
      
  </template>
  
  <style>
  
  .background{
      min-height: 100%;
      min-width: 100%;
  }
  
  .bg {
    position: fixed; 
    top: -50%; 
    left: -50%; 
    width: 200%; 
    height: 200%;
  }
  .bg img {
    position: absolute; 
    top: 0; 
    left: 0; 
    right: 0; 
    bottom: 0; 
    margin: auto; 
    max-width: 30%;
    max-height: 30%;
  }
  </style>
  