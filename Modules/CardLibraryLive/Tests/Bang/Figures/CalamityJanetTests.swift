//
//  CalamityJanetTest.swift
//
//
//  Created by Hugues Telolahy on 20/11/2023.
//

import GameCore
import Testing

struct CalamityJanetTests {
    @Test func playingBang_shouldShoot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.calamityJanet])
                    .withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.bang, player: "p1"),
            .choose("p2", player: "p1"),
            .play(.bang, player: "p1", target: "p2"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func playingMissed_shouldShoot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.calamityJanet])
                    .withHand([.missed])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.missed, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.missed, player: "p1"),
            .choose("p2", player: "p1"),
            .play(.missed, player: "p1", target: "p2", alias: .bang),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func beingShot_holdingMissed_shouldAskToCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.calamityJanet])
                .withHand([.missed])
            }
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .choose(.missed, player: "p1"),
            .play(.missed, player: "p1", target: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_holdingBang_shouldAskToCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.calamityJanet])
                .withHand([.bang])
            }
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .choose(.bang, player: "p1"),
            .play(.bang, player: "p1", target: "p1", alias: .missed),
            .counterShoot(player: "p1")
        ])
    }
}
