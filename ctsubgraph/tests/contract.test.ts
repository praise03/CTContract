import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Address, BigInt } from "@graphprotocol/graph-ts"
import { BuyOrder } from "../generated/schema"
import { BuyOrder as BuyOrderEvent } from "../generated/Contract/Contract"
import { handleBuyOrder } from "../src/contract"
import { createBuyOrderEvent } from "./contract-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let tokenContractAddress = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let amount = BigInt.fromI32(234)
    let recipient = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let newBuyOrderEvent = createBuyOrderEvent(
      tokenContractAddress,
      amount,
      recipient
    )
    handleBuyOrder(newBuyOrderEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("BuyOrder created and stored", () => {
    assert.entityCount("BuyOrder", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "BuyOrder",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "tokenContractAddress",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "BuyOrder",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "amount",
      "234"
    )
    assert.fieldEquals(
      "BuyOrder",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "recipient",
      "0x0000000000000000000000000000000000000001"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
