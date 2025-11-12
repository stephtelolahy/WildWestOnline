//
//  ActivatePlayableCardsTest.swift
//
//
//  Created by Hugues Telolahy on 05/06/2023.
//

import Testing
import GameFeature

struct ActivatePlayableCardsTest {
    @Test func updateGame_withPlayableCards_shouldActivate() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.saloon, .gatling, .beer, .missed])
                    .withMaxHealth(4)
                    .withHealth(2)
            }
            .withPlayer("p2")
            .withTurn("p1")
            .withDeck(["c1"])
            .withAutoActivatePlayableCardsOnIdle(true)
            .build()

        // When
        let action = GameFeature.Action.dummy
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .activate([.saloon, .gatling], player: "p1")
        ])
    }

    @Test func activatingCards_withoutPlayableCards_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer, .missed])
                    .withMaxHealth(4)
                    .withHealth(4)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withTurn("p1")
            .withAutoActivatePlayableCardsOnIdle(true)
            .build()

        // When
        let action = GameFeature.Action.dummy
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result.isEmpty)
    }

    @Test func activatingCards_withDeepPath_shouldCompleteWithReasonableDelay() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand((1...10).map { "\(String.beer)-\($0)" })
                    .withMaxHealth(4)
                    .withHealth(1)
                    .withAbilities([.endTurn])
            }
            .withPlayer("p2") {
                $0.withMaxHealth(2)
                    .withAbilities([.drawCardsOnTurnStarted])
            }
            .withTurn("p1")
            .withAutoActivatePlayableCardsOnIdle(true)
            .build()

        // When
        let action = GameFeature.Action.dummy
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .activate([.endTurn], player: "p1")
        ])
    }
}
