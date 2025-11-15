//
//  JailTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature

struct JailTest {
    @Test func playingJail_againstAnyPlayer_shouldHandicap() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.jail])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.jail, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .handicap(.jail, target: "p2", player: "p1")
        ])
    }

    @Test func playingJail_cancellingPlayerChoice_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.jail])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.jail, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .choose(.choicePass, player: "p1")
        ])
    }

    @Test func triggeringJail_flippedCardIsHearts_shouldEscapeFromJail() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.jail])
                    .withAbilities([.draw2CardsOnTurnStarted])
                    .withCardsPerDraw(1)
            }
            .withDeck(["c1-2♥️", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .draw(),
            .discardInPlay(.jail, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func triggeringJail_flippedCardIsNotHearts_shouldSkipTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.jail])
                    .withAbilities([.draw2CardsOnTurnStarted])
                    .withCardsPerDraw(1)
            }
            .withPlayer("p2")
            .withDeck(["c1-A♠️", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .draw(),
            .endTurn(player: "p1"),
            .discardInPlay(.jail, player: "p1")
        ])
    }
}
