<template>
    <div class="w-full justify-center p-10 flex flex-row">
      
  
      <div class="w-d  w-5/6">
        <div class="container  mx-auto px-4 sm:px-8">
          <div class="py-2">
            <div class="-mx-4 sm:-mx-8 px-4 sm:px-8 overflow-x-auto">
              <div
                class="
                 bg-black
                  inline-block
                  min-w-full
                  shadow-md
                  rounded-md
                  overflow-hidden
                "
              >
                <table class="min-w-full leading-normal">
                  <thead class="bg-gray-400">
                    <tr>
                      <th
                        class="
                          px-5
                          py-3
                          border-b-2 border-gray-200
                          
                          text-left text-xs
                          font-semibold
                          text-gray-700
                          uppercase
                          tracking-wider
                        "
                      >TimeStamp</th>
                      <th
                        class="
                          px-5
                          py-3
                          border-b-2 border-gray-200
                          
                          text-left text-xs
                          font-semibold
                          text-gray-700
                          uppercase
                          tracking-wider
                        "
                      >
                        Token Address
                      </th>
                      <th
                        class="
                          px-5
                          py-3
                          border-b-2 border-gray-200
                          
                          text-left text-xs
                          font-semibold
                          text-gray-700
                          uppercase
                          tracking-wider
                        "
                      >
                        Amount
                      </th>
                      <th
                        class="
                          px-5
                          py-3
                          border-b-2 border-gray-200
                          
                          text-left text-xs
                          font-semibold
                          text-gray-700
                          uppercase
                          tracking-wider
                        "
                      >
                        Accounts Distributed to
                      </th>
                      
                      
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="event in disperceEvents" :key="event.blockTimestamp" class="hover:bg-gray-900" >
                      <td
                        class="
                          px-1
                          py-5
                          border-b border-gray-200
                          text-sm
                        "
                      >
                        <p class="text-white whitespace-no-wrap">{{ moment.unix(event.blockTimestamp).format("MM/DD/YYYY") }} ( {{ getRelativeTime(event.blockTimestamp) }} )</p>
                      </td>
                      <td
                        class="
                          px-4
                          py-5
                          text-white
                          border-b border-gray-200
                          text-sm
                        "
                      >
                        <div class="flex">
                          <span>0x326C977E6efc84E512bB9C30f76E30c160eD06FB</span>
                        </div>
                      </td>
                      <td
                        class="
                          px-5
                          py-5
                          border-b border-gray-200
                          
                          text-sm
                        "
                      >
                        <p class="text-white whitespace-no-wrap">
                           {{ (fromDecimals(event.tokensToDistributePerUser)).toFixed(3) }} TOKENS
                        </p>
                      </td>
                      <td
                        class="
                          px-5
                          py-5
                          border-b border-gray-200
                          
                          text-sm
                        "
                      >

                        <p v-for="subscriber in event.fundedSubscribers" class="text-white whitespace-no-wrap">
                            {{ subscriber }}
                        </p>
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
import { watch, ref } from "vue";
import { useQuery } from '@vue/apollo-composable'
import gql from 'graphql-tag'
import moment from 'moment';
moment().format();

const disperceEvents = ref([])

const { result, error } = useQuery(gql`
	query fetchDisperces {
		logDisperces(first:10){
            swapAmount
            receivedTokens
            tokensToDistributePerUser
            fundedSubscriberCount
            fundedSubscribers
            blockTimestamp
        }
	}
`)

watch(result, value => {
  // console.log(value.logDisperces)
  disperceEvents.value = value.logDisperces
  // for (let index = 0; index < value.logDisperces.length; index++) {
  //   disperceEvents.value.push( Array(value.logDisperces[index]))

    
  // }
  // console.log(disperceEvents.value.sort(function(x, y){
  //         return y.blockTimestamp - x.blockTimestamp;
  //       }))
		
})

const getRelativeTime = (timestamp) => {
  const parsedTime = moment.unix(timestamp);
  return parsedTime.fromNow()
}
//helper funcitons
function toDecimals (amount) {
	return String(amount * (10 ** 18));
}

function fromDecimals(amount){
	return Number(amount) / (10 ** 18);
}
</script>