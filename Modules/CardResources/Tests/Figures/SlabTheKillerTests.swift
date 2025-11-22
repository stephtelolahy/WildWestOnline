//
//  SlabTheKillerTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 29/05/2024.
//

import CardResources
import GameFeature
import Testing

struct SlabTheKillerTests {
    @Test func playingBang_withTwoMissed() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.slabTheKiller])
                    .withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withHand([.missed1, .missed2])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(
            result == [
                .choose("p2", player: "p1"),
                .play(.bang, player: "p1", target: "p2"),
                .shoot("p2"),
                .choose(.missed1, player: "p2"),
                .discardHand(.missed1, player: "p2"),
                .counterShoot(player: "p2"),
                .choose(.missed2, player: "p2"),
                .discardHand(.missed2, player: "p2"),
                .counterShoot(player: "p2")
            ])
    }

    @Test func playingBang_withSuccessfulBarrelAndMissed() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.slabTheKiller])
                    .withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withInPlay([.barrel])
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(
            result == [
                .choose("p2", player: "p1"),
                .play(.bang, player: "p1", target: "p2"),
                .shoot("p2"),
                .draw(player: "p2"),
                .counterShoot(player: "p2"),
                .choose(.missed, player: "p2"),
                .discardHand(.missed, player: "p2"),
                .counterShoot(player: "p2")
            ])
    }

    @Test func playingBang_withOneMissed_shouldDamage() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.slabTheKiller])
                    .withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withHealth(2)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(
            result == [
                .choose("p2", player: "p1"),
                .play(.bang, player: "p1", target: "p2"),
                .shoot("p2"),
                .choose(.missed, player: "p2"),
                .discardHand(.missed, player: "p2"),
                .counterShoot(player: "p2"),
                .damage(1, player: "p2")
            ])
    }
}
