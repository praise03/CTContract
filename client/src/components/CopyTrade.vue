<template>
<div>
    <aside class="text-right ">
        <button class="s px-8 py-3 text-gray-300 font-extralight text-lg rounded-sm">Subscription balance: {{fromDecimals(subBalance)}} MATIC</button>
    </aside>
<div class=" w-full flex items-center justify-center dark:bg-gray-900">

    <!-- Author card -->
    <div
        class="relative w-full max-w-2xl my-8 md:my-16 flex flex-col items-start space-y-4 sm:flex-row sm:space-y-0 sm:space-x-6 px-4 py-8 border-2 border-dashed border-gray-400 dark:border-gray-400 shadow-lg rounded-lg">

        <span class="absolute text-md bg-black text-white font-extrabold top-0 left-0 rounded-br-lg rounded-tl-lg px-2 py-1 bg-primary-100 dark:bg-gray-900 dark:text-gray-300 border-gray-400 dark:border-gray-400 border-b-2 border-r-2 border-dashed ">
            #1
        </span>

        <div class="w-full flex justify-center sm:justify-start sm:w-auto">
            <img class="object-cover w-60 h-32 mt-3 mr-3 rounded-full" src="/profile.jpg">
        </div>

        <div class="w-full sm:w-auto flex flex-col items-center sm:items-start">

            <p class="font-display mb-2 text-2xl font-semibold dark:text-gray-200" itemprop="author">
                E. Norma Stitz
            </p>

            <div class="mb-4 md:text-lg text-gray-400">
                <p>Stitz is a seasoned DeFi trader with over 10 years experience trading cryptocurrency and has
                    amassed a total profit of over $100 million.</p>
            </div>

            <div class="flex gap-4">

                <a title="youtube url" href="#" target="_blank"
                    rel="noopener noreferrer">
                    <svg class="h-6 w-6 dark:text-gray-300" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                        fill="none">
                        <path fill-rule="evenodd" clip-rule="evenodd"
                            d="M20.5949 4.45999C21.5421 4.71353 22.2865 5.45785 22.54 6.40501C22.9982 8.12001 23 11.7004 23 11.7004C23 11.7004 23 15.2807 22.54 16.9957C22.2865 17.9429 21.5421 18.6872 20.5949 18.9407C18.88 19.4007 12 19.4007 12 19.4007C12 19.4007 5.12001 19.4007 3.405 18.9407C2.45785 18.6872 1.71353 17.9429 1.45999 16.9957C1 15.2807 1 11.7004 1 11.7004C1 11.7004 1 8.12001 1.45999 6.40501C1.71353 5.45785 2.45785 4.71353 3.405 4.45999C5.12001 4 12 4 12 4C12 4 18.88 4 20.5949 4.45999ZM15.5134 11.7007L9.79788 15.0003V8.40101L15.5134 11.7007Z"
                            stroke="currentColor" stroke-linejoin="round"></path>
                    </svg>
                </a>

                <a title="website url" href="#" target="_blank" rel="noopener noreferrer">
                    <svg class="h-6 w-6 dark:text-gray-300" xmlns="http://www.w3.org/2000/svg" fill="none"
                        viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round"
                            d="M12 21a9.004 9.004 0 008.716-6.747M12 21a9.004 9.004 0 01-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 017.843 4.582M12 3a8.997 8.997 0 00-7.843 4.582m15.686 0A11.953 11.953 0 0112 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 0121 12c0 .778-.099 1.533-.284 2.253m0 0A17.919 17.919 0 0112 16.5c-3.162 0-6.133-.815-8.716-2.247m0 0A9.015 9.015 0 013 12c0-1.605.42-3.113 1.157-4.418">
                        </path>
                    </svg>
                </a>

                <a href="">
                    <img height="10" width="23" src="https://cdn4.iconfinder.com/data/icons/picons-social/57/38-instagram-2-256.png" alt="">
                </a>

                <a href="">
                    <img height="10" width="23" src="https://cdn4.iconfinder.com/data/icons/social-media-black-white-2/1227/X-64.png" alt="">
                </a>

                <a href="">
                    <img height="10" width="23" src="https://debank.com/512.png" alt="">
                </a>

            </div>
            <div>
                <input v-model="subscribeInputAmount" type="text" class="s p-4 rounded-sm" placeholder=" Greater than 0.01 MATIC" >
                <button @click="subscribe()" class="px-16 py-4 rounded-md mt-5 justify-center bg-orange-800 hover:bg-orange-900 text-white font-extrabold">SUBSCRIBE</button>
            
            </div>
            <p class="f font-extralight text-white text-sm">*Subscribing means you agree to deposit an amount <span class="font-extrabold">>0.01 MATIC</span> to copy all trades executed by this individual</p>
        </div>
        
    </div>
</div>

<div class="justify-center text-center content-center">
    <h1 class="font-extrabold text-lg text-white ">SWAP INTERFACE</h1>

    <div class="p-1  flex flex-col items-center justify-center">
        <div class="s space-x-5 w-40 bg-orange-700 p-1 mb-4 mt-2 rounded-sm">
            <span @click="tab = 'buy'" class="font-thin cursor-pointer text-2xl" :class="{'text-white': tab == 'buy'}">Buy</span>
            <span @click="tab = 'sell'" class="font-thin cursor-pointer text-2xl vl" :class="{'text-white': tab == 'sell'}">Sell</span>
        </div>
        
        <Transition name="slide-fade">
     <div v-show="tab == 'buy'">
        <div class="">
            <h3>BUY</h3>
            
            <div class="px-4 py-2 border rounded-md flex flex-col">
            <div class="flex">

            <input 
                autocomplete="off"
                autocorrect="off"
                type="text"
                pattern="^[0-9]*[.,]?[0-9]*$"
                placeholder="0.0"
                minlength="1"
                maxlength="79"
                spellcheck="false"
                class=" focus:outline-none bg-gray-500 text-gray-100 " 
				v-model="buyTokenAddress"
                />
                <button class="flex bg-gray-200 rounded-sm px-4 py-1 uppercase" >
                 Token Address</button>
        

            </div>
            </div>
        </div>
        +
     <div class="">
        <div class="px-4 py-2 border rounded-md flex flex-col">
          <div class="flex justify-center ">

          <input 
            autocomplete="off"
            autocorrect="off"
            type="text"
            pattern="^[0-9]*[.,]?[0-9]*$"
            placeholder="0.0"
            minlength="1"
            maxlength="79"
            spellcheck="false"
            class=" bg-gray-500 text-gray-100 focus:outline-none  " 
			v-model="buyInputAmount"
            />

            <button class="flex bg-gray-200 rounded-sm px-4 py-1 uppercase" > MATIC</button>
          </div>
        </div>
      </div>
	
        
        <button @click="swapMaticToToken()" class="w-full bg-teal-600 hover:bg-teal-700 mt-4 rounded-md py-2  text-white" >Swap</button>
     </div>
    </Transition>

        <!-- SELL -->

        <Transition name="slide-fade">
        <div v-show="tab == 'sell'">
        <div class="">
            <h3>SELL</h3>
            <div class="px-4 py-2 border rounded-md flex flex-col">
            <div class="flex">

            <input 
                autocomplete="off"
                autocorrect="off"
                type="text"
                pattern="^[0-9]*[.,]?[0-9]*$"
                placeholder="0.0"
                minlength="1"
                maxlength="79"
                spellcheck="false"
                class=" focus:outline-none bg-gray-500 text-gray-100 " 
				v-model="sellTokenAddress"
                />
                <button class="flex bg-gray-200 rounded-sm px-4 py-1 uppercase" >
                 Token Address</button>
        

            </div>
            </div>
        </div>
        +
     <div class="">
        <div class="px-4 py-2 border rounded-md flex flex-col">
          <div class="flex justify-center ">

          <input 
            autocomplete="off"
            autocorrect="off"
            type="text"
            pattern="^[0-9]*[.,]?[0-9]*$"
            placeholder="0.0"
            minlength="1"
            maxlength="79"
            spellcheck="false"
            class=" bg-gray-500 text-gray-100 focus:outline-none  " 
			v-model="sellTokenAmount"
            />

            <button class="flex bg-gray-200 rounded-sm px-4 py-1 uppercase" > TOKEN AMOUNT</button>
          </div>
        </div>
      </div>
	
        
        <button @click="swapTokenToMatic()" class="w-full bg-teal-600 hover:bg-teal-700 mt-4 rounded-md py-2  text-white" >Swap</button>
     </div>
     </Transition>

     </div>

    
    
</div>

<div class="justify-center mt-10 text-center content-center">
    <h1 class="font-extrabold text-lg text-white ">RECENT TRADES</h1>
    <Orders />
</div>
</div>
</template>

<script setup lang="ts">
import { onBeforeMount, ref } from "vue";
import { useRouter } from "vue-router";
import { CTMaticContract__factory } from "../../../types/factories/contracts/MumbaiCTContract.sol/CTMaticContract__factory"
import { CTMaticContract } from "../../../types/contracts/MumbaiCTcontract.sol/CTMaticContract"
import { ethers } from "ethers";
import { useToast, POSITION } from "vue-toastification";
import Orders from "./Orders.vue";

import {CTMaticAbi, CTMaticContractAddress } from "../constants.js"


const currentAccount = ref("");
const tab = ref("buy");
let provider;
let CTContract: CTMaticContract;
const subscribeInputAmount = ref(0);
const output = ref("");
const subBalance = ref(0);
const toast = useToast()

//Swap Interface data
const buyTokenAddress = ref("")
const buyInputAmount = ref(0)
const sellTokenAddress = ref("")
const sellTokenAmount = ref(0)

function toastSee() {
    toast.success("I'm a toast", { position: POSITION.TOP_LEFT });
    console.log(CTMaticContractAddress)
}

const loadCurrentAccount = async() => {
	if (typeof window.ethereum !== 'undefined') {
		currentAccount.value = (await window.ethereum.request({ method: 'eth_requestAccounts' }))[0];
	}
	console.log("Current Account: " + currentAccount.value);
}

const loadContract = async () => {
	await loadCurrentAccount()
	provider = new ethers.providers.Web3Provider(
        window.ethereum,
    );

	if (currentAccount.value == "") {
		CTContract = CTMaticContract__factory.connect(
		CTMaticContractAddress,
		provider
		);
	} else {
		CTContract =  CTMaticContract__factory.connect(
		CTMaticContractAddress,
		provider.getSigner(currentAccount.value)
		);
  }

    await loadUserBalance();
  
}
loadContract()

async function loadUserBalance() {
    const tx = await CTContract.userBalance(currentAccount.value);
    console.log(tx.toString())
    subBalance.value = tx.toString()
}

async function subscribe() {
    const msgValue = toDecimals(subscribeInputAmount.value);
    const tx = await CTContract.subscribe({value: msgValue});
    await tx.wait(1);
    toast.success("Subscribed with " + subscribeInputAmount.value + "Successfully", {position: POSITION.TOP_LEFT})
    subscribeInputAmount.value = 0;
    await loadUserBalance();
}

async function swapMaticToToken() {
    const msgValue = toDecimals(buyInputAmount.value)
    const tx = await CTContract.convertExactMaticToToken(buyTokenAddress.value, {value: msgValue})
    await tx.wait(1);
    toast.success('Successfully swapped to token at ' + buyTokenAddress.value + ' for ' + buyInputAmount.value + ' MATIC!')
    buyInputAmount.value = 0
}

async function swapTokenToMatic() {
    const msgValue = toDecimals(sellTokenAmount.value)
    const tx = await CTContract.convertTokenToMatic(msgValue, sellTokenAddress.value);
    await tx.wait(1)
    toast.success('Successfully sold ' + sellTokenAmount.value + ' of token at ' + sellTokenAddress.value + '!')
    sellTokenAmount.value = 0
}


//helper funcitons
function toDecimals (amount) {
	return String(amount * (10 ** 18));
}

function fromDecimals(amount){
	return Number(amount) / (10 ** 18);
}

</script>


<style>
.slide-fade-enter-active {
  transition: all 0.3s ease-out;
}

.slide-fade-leave-active {
  transition: all 0.8s cubic-bezier(1, 0.5, 0.8, 1);
}

.slide-fade-enter-from,
.slide-fade-leave-to {
  transform: translateX(20px);
  opacity: 0;
}

.vl {
  border-left: 3px solid white;
  height: 10px;
  padding: 8px;
}

</style>