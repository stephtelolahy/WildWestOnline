//
//  ActivatePlayableCardsOnIdleTests.swift
//
//
//  Created by Hugues Telolahy on 05/06/2023.
//

import GameCore
import Testing

struct ActivatePlayableCardsOnIdleTests {
    /*
    @Test func activatingCards_withPlayableCards_shouldActivate() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.saloon, .gatling])
                    .withAttributes([.maxHealth: 4])
                    .withHealth(2)
            }
            .withPlayer("p2") {
                $0.withAttributes([.maxHealth: 4])
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.nothing
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .activate([.saloon, .gatling], player: "p1")
        ])
    }

    @Test func activatingCards_withoutPlayableCards_shouldDoNothing() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.beer, .missed])
                    .withAttributes([.maxHealth: 4])
                    .withHealth(4)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.nothing
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [])
    }

    @Test func activatingCards_withDeepPath_shouldCompleteWithReasonableDelay() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand((1...10).map { "\(String.beer)-\($0)" })
                    .withAttributes([.maxHealth: 4])
                    .withAbilities([.endTurn])
                    .withHealth(1)
            }
            .withPlayer("p2") {
                $0.withAttributes([.maxHealth: 4, .startTurnCards: 2])
                    .withAbilities([.drawOnStartTurn])
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.nothing
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [.activate([.endTurn], player: "p1")])
    }
     */
}
