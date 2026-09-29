//
//  MollyStarkTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct MollyStarkTest {
    @Test func playingMissedOutOfTurn_shouldDrawACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.mollyStark])
                    .withHand([.missed])
            }
            .withPlayer("p2")
            .withTurn("p2")
            .withDeck(["c1"])
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .choose(.missed, player: "p1"),
            .play(.missed, player: "p1", target: "p1"),
            .drawDeck(player: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func discardingBangOutOfTurn_shouldDrawACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.mollyStark])
                    .withHand([.bang])
            }
            .withPlayer("p2") {
                $0.withHand([.indians])
            }
            .withTurn("p2")
            .withDeck(["c1"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.indians, player: "p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.indians, player: "p2"),
            .play(.indians, player: "p2"),
            .choose(.bang, player: "p1"),
            .discardHand(.bang, player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func playingCardInHerTurn_shouldNotDraw() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.mollyStark])
                    .withHand([.beer])
                    .withHealth(1)
                    .withMaxHealth(4)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withTurn("p1")
            .withDeck(["c1"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.beer, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.beer, player: "p1"),
            .play(.beer, player: "p1"),
            .heal(1, player: "p1")
        ])
    }
}
