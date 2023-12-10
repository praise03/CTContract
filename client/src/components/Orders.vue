<template>
  <div class="w-full justify-center p-10 flex flex-row">


    <div class="w-d  w-5/6">
      <div class="container  mx-auto px-4 sm:px-8">
        <div class="py-2">
          <div class="-mx-4 sm:-mx-8 px-4 sm:px-8 overflow-x-auto">
            <div class="
                 bg-black
                  inline-block
                  min-w-full
                  shadow-md
                  rounded-md
                  overflow-hidden
                ">
              <table class="min-w-full leading-normal">
                <thead class="bg-gray-400">
                  <tr>
                    <th class="
                          px-5
                          py-3
                          border-b-2 border-gray-200
                          
                          text-left text-xs
                          font-semibold
                          text-gray-700
                          uppercase
                          tracking-wider
                        ">TimeStamp</th>
                    <th class="
                          px-5
                          py-3
                          border-b-2 border-gray-200
                          
                          text-left text-xs
                          font-semibold
                          text-gray-700
                          uppercase
                          tracking-wider
                        ">
                      Token Address
                    </th>
                    <th class="
                          px-5
                          py-3
                          border-b-2 border-gray-200
                          
                          text-left text-xs
                          font-semibold
                          text-gray-700
                          uppercase
                          tracking-wider
                        ">
                      AMOUNT
                    </th>
                    <th class="
                          px-5
                          py-3
                          border-b-2 border-gray-200
                          
                          text-left text-xs
                          font-semibold
                          text-gray-700
                          uppercase
                          tracking-wider
                        ">
                      SENDER
                    </th>
                    <th class="
                          px-5
                          py-3
                          border-b-2 border-gray-200
                        
                          text-left text-xs
                          font-semibold
                          text-gray-700
                          uppercase
                          tracking-wider
                        ">

                    </th>

                  </tr>
                </thead>
                <tbody>
                  <tr v-for="order in allOrders" :key="order.blockTimestamp" class="hover:bg-gray-900">
                    <td class="
                          px-1
                          py-5
                          border-b border-gray-200
                          text-sm
                        ">
                      <p class="text-white whitespace-no-wrap">{{ moment.unix(order.blockTimestamp).format("MM/DD/YYYY")
                      }} ( {{ getRelativeTime(order.blockTimestamp) }}) </p>
                    </td>
                    <td class="
                          px-4
                          py-5
                          text-white
                          border-b border-gray-200
                          text-sm
                        ">
                      <div class="flex">
                        <span>{{ order.tokenContractAddress }}</span>
                      </div>
                    </td>
                    <td class="
                          px-5
                          py-5
                          border-b border-gray-200
                          
                          text-sm
                        ">
                      <p class="text-white whitespace-no-wrap">
                        {{ (fromDecimals(order.amount)).toFixed(3) }} MATIC
                      </p>
                    </td>
                    <td class="
                          px-5
                          py-5
                          border-b border-gray-200
                          
                          text-sm
                        ">
                      <p class="text-white whitespace-no-wrap">
                        {{ order.recipient }}
                      </p>
                    </td>
                    <td class="
                          px-5
                          py-5
                          border-b border-gray-200
                          
                          text-sm
                        ">
                      <button @click="copyTrade(order.tokenContractAddress, order.amount)"
                        class="bg-orange-700 rounded-md px-3 py-2 text-white whitespace-no-wrap hover:bg-orange-800">COPY</button>
                    </td>
                  </tr>

                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from "vue";
import { useQuery } from '@vue/apollo-composable'
import { CTMaticContract__factory } from "../../../types/factories/contracts/MumbaiCTContract.sol/CTMaticContract__factory"
import { CTMaticContract } from "../../../types/contracts/MumbaiCTcontract.sol/CTMaticContract"
import { CTMaticContractAddress } from "../constants.js"
import gql from 'graphql-tag'
import { ethers, utils } from "ethers";
import { useToast, POSITION } from "vue-toastification";
import moment from 'moment';
moment().format();

const toast = useToast()
const currentAccount = ref("");
let provider;
let CTContract: CTMaticContract;
const allOrders = ref([])

const getRelativeTime = (timestamp) => {
  const parsedTime = moment.unix(timestamp);
  return parsedTime.fromNow()
}

const { result, error } = useQuery(gql`
	query fetchAllOrders {
		buyOrders(first: 100) {
    tokenContractAddress
    amount
    recipient
    blockTimestamp
  }
  sellOrders(first: 100){
    tokenContractAddress
    amount
    recipient
    blockTimestamp
  }
	}
	`)

watch(result, value => {
  const all = value.buyOrders.concat(value.sellOrders)
  allOrders.value = all.sort(function (x, y) {
    return y.blockTimestamp - x.blockTimestamp;
  })
  console.log(allOrders.value)
})

const loadCurrentAccount = async () => {
  if (typeof window.ethereum !== 'undefined') {
    currentAccount.value = utils.getAddress((await window.ethereum.request({ method: 'eth_requestAccounts' }))[0]);
  }
}

const loadContract = async () => {
  await loadCurrentAccount()
  provider = new ethers.providers.Web3Provider(window.ethereum,);

  if (currentAccount.value == "") {
    CTContract = CTMaticContract__factory.connect(CTMaticContractAddress, provider);
  } else {
    CTContract = CTMaticContract__factory.connect(CTMaticContractAddress, provider.getSigner(currentAccount.value));
  }

}
loadContract()

async function copyTrade(tokenContractAddress, maticAmount) {
  const tx = await CTContract.swapExactMaticToToken(tokenContractAddress, {value: maticAmount})
  await tx.wait(1);
  toast.success('Successfully swapped to token at ' + tokenContractAddress + ' for ' + fromDecimals(maticAmount).toFixed(3) + ' MATIC!', { position: POSITION.TOP_LEFT })
}

if (window.ethereum) {
  window.ethereum.on("accountsChanged", async function () {
    await loadContract();
  });
}

//helper funcitons
function toDecimals(amount) {
  return String(amount * (10 ** 18));
}

function fromDecimals(amount) {
  return Number(amount) / (10 ** 18);
}
</script>