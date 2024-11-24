//
//  ActivatePlayableCardsTest.swift
//
//
//  Created by Hugues Telolahy on 05/06/2023.
//

import Testing
import Bang

struct ActivatePlayableCardsTest {
    @Test func updateGame_withPlayableCards_shouldActivate() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.saloon, .gatling])
                    .withMaxHealth(4)
                    .withHealth(2)
            }
            .withPlayer("p2")
            .withTurn("p1")
            .withDeck(["c1"])
            .build()

        // When
        let action = GameAction(kind: .queue, payload: .init())
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .activate([.saloon, .gatling], player: "p1")
        ])
    }

    @Test func activatingCards_withoutPlayableCards_shouldDoNothing() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer, .missed])
                    .withMaxHealth(4)
                    .withHealth(4)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction(kind: .queue, payload: .init())
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result.isEmpty)
    }

    @Test func activatingCards_withDeepPath_shouldCompleteWithReasonableDelay() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand((1...10).map { "\(String.beer)-\($0)" })
                    .withMaxHealth(4)
                    .withAbilities([.defaultEndTurn])
                    .withHealth(1)
            }
            .withPlayer("p2") {
                $0.withMaxHealth(2)
                    .withAbilities([.defaultDraw2CardsOnTurnStarted])
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameAction(kind: .queue, payload: .init())
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .activate([.defaultEndTurn], player: "p1")
        ])
    }
}
