import {
  BuyOrder as BuyOrderEvent,
  OwnershipTransferred as OwnershipTransferredEvent,
  SellOrder as SellOrderEvent,
  logDisperce as logDisperceEvent
} from "../generated/Contract/Contract"
import {
  BuyOrder,
  OwnershipTransferred,
  SellOrder,
  logDisperce
} from "../generated/schema"

export function handleBuyOrder(event: BuyOrderEvent): void {
  let entity = new BuyOrder(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.tokenContractAddress = event.params.tokenContractAddress
  entity.amount = event.params.amount
  entity.recipient = event.params.recipient

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleOwnershipTransferred(
  event: OwnershipTransferredEvent
): void {
  let entity = new OwnershipTransferred(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.previousOwner = event.params.previousOwner
  entity.newOwner = event.params.newOwner

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSellOrder(event: SellOrderEvent): void {
  let entity = new SellOrder(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.tokenContractAddress = event.params.tokenContractAddress
  entity.amount = event.params.amount
  entity.recipient = event.params.recipient

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handlelogDisperce(event: logDisperceEvent): void {
  let entity = new logDisperce(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.swapAmount = event.params.swapAmount
  entity.receivedTokens = event.params.receivedTokens
  entity.tokensToDistributePerUser = event.params.tokensToDistributePerUser
  entity.fundedSubscriberCount = event.params.fundedSubscriberCount
  entity.fundedSubscribers = event.params.fundedSubscribers

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
