//
//  MissedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

import Testing
import GameFeature

struct MissedTest {
    @Test func beingShot_discardingMissed_shouldCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHand([.missed1, .missed2])
            }
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let choiceHandler = choiceHandlerWithResponses([
            .init(options: [.missed1, .missed2, .choicePass], selection: .missed2)
        ])
        let result = try await dispatchUntilCompleted(action, state: state, choiceHandler: choiceHandler)

        // Then
        #expect(result == [
            .shoot("p1"),
            .choose(.missed2, player: "p1"),
            .discardHand(.missed2, player: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_choosingPass_shouldDealDamage() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHealth(2)
                    .withHand([.missed])
            }
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let choiceHandler = choiceHandlerWithResponses([
            .init(options: [.missed, .choicePass], selection: .choicePass)
        ])
        let result = try await dispatchUntilCompleted(action, state: state, choiceHandler: choiceHandler)

        // Then
        #expect(result == [
            .shoot("p1"),
            .choose(.choicePass, player: "p1"),
            .damage(1, player: "p1")
        ])
    }

    @Test func beingShot_noCounterCard_shouldDealDamage() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHealth(2)
            }
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .shoot("p1"),
            .damage(1, player: "p1")
        ])
    }
}

private extension String {
    static let missed1 = "\(String.missed)-1"
    static let missed2 = "\(String.missed)-2"
}
