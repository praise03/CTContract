import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  BuyOrder,
  OwnershipTransferred,
  SellOrder,
  logDisperce
} from "../generated/Contract/Contract"

export function createBuyOrderEvent(
  tokenContractAddress: Address,
  amount: BigInt,
  recipient: Address
): BuyOrder {
  let buyOrderEvent = changetype<BuyOrder>(newMockEvent())

  buyOrderEvent.parameters = new Array()

  buyOrderEvent.parameters.push(
    new ethereum.EventParam(
      "tokenContractAddress",
      ethereum.Value.fromAddress(tokenContractAddress)
    )
  )
  buyOrderEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )
  buyOrderEvent.parameters.push(
    new ethereum.EventParam("recipient", ethereum.Value.fromAddress(recipient))
  )

  return buyOrderEvent
}

export function createOwnershipTransferredEvent(
  previousOwner: Address,
  newOwner: Address
): OwnershipTransferred {
  let ownershipTransferredEvent = changetype<OwnershipTransferred>(
    newMockEvent()
  )

  ownershipTransferredEvent.parameters = new Array()

  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam(
      "previousOwner",
      ethereum.Value.fromAddress(previousOwner)
    )
  )
  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam("newOwner", ethereum.Value.fromAddress(newOwner))
  )

  return ownershipTransferredEvent
}

export function createSellOrderEvent(
  tokenContractAddress: Address,
  amount: BigInt,
  recipient: Address
): SellOrder {
  let sellOrderEvent = changetype<SellOrder>(newMockEvent())

  sellOrderEvent.parameters = new Array()

  sellOrderEvent.parameters.push(
    new ethereum.EventParam(
      "tokenContractAddress",
      ethereum.Value.fromAddress(tokenContractAddress)
    )
  )
  sellOrderEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )
  sellOrderEvent.parameters.push(
    new ethereum.EventParam("recipient", ethereum.Value.fromAddress(recipient))
  )

  return sellOrderEvent
}

export function createlogDisperceEvent(
  swapAmount: BigInt,
  receivedTokens: BigInt,
  tokensToDistributePerUser: BigInt,
  fundedSubscriberCount: i32,
  fundedSubscribers: Array<Address>
): logDisperce {
  let logDisperceEvent = changetype<logDisperce>(newMockEvent())

  logDisperceEvent.parameters = new Array()

  logDisperceEvent.parameters.push(
    new ethereum.EventParam(
      "swapAmount",
      ethereum.Value.fromUnsignedBigInt(swapAmount)
    )
  )
  logDisperceEvent.parameters.push(
    new ethereum.EventParam(
      "receivedTokens",
      ethereum.Value.fromUnsignedBigInt(receivedTokens)
    )
  )
  logDisperceEvent.parameters.push(
    new ethereum.EventParam(
      "tokensToDistributePerUser",
      ethereum.Value.fromUnsignedBigInt(tokensToDistributePerUser)
    )
  )
  logDisperceEvent.parameters.push(
    new ethereum.EventParam(
      "fundedSubscriberCount",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(fundedSubscriberCount))
    )
  )
  logDisperceEvent.parameters.push(
    new ethereum.EventParam(
      "fundedSubscribers",
      ethereum.Value.fromAddressArray(fundedSubscribers)
    )
  )

  return logDisperceEvent
}
