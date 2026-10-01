//
//  MissedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

import Testing
import GameCore

struct MissedTest {
    @Test func beingShot_discardingMissed_shouldCounter() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", hand: [.missed1, .missed2])
            .build()

        let choiceHandler = choiceHandlerWithResponses([
            .init(options: [.missed1, .missed2, .choicePass], selection: .missed2)
        ])
        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state, choiceHandler: choiceHandler)

        #expect(result == [
            .shoot("p1"),
            .choose(.missed2, player: "p1"),
            .play(.missed2, player: "p1", target: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_choosingPass_shouldDealDamage() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 2, hand: [.missed])
            .build()

        let choiceHandler = choiceHandlerWithResponses([
            .init(options: [.missed, .choicePass], selection: .choicePass)
        ])
        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state, choiceHandler: choiceHandler)

        #expect(result == [
            .shoot("p1"),
            .choose(.choicePass, player: "p1"),
            .damage(1, player: "p1")
        ])
    }

    @Test func beingShot_noCounterCard_shouldDealDamage() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 2)
            .build()

        let result = try await dispatchUntilCompleted(.shoot("p1"), state: state, ignoreError: true)

        #expect(result == [
            .shoot("p1"),
            .damage(1, player: "p1")
        ])
    }
}
