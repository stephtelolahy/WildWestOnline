//
//  DynamiteTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct DynamiteTests {
    /*
    @Test func playDynamite_shouldEquip() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.dynamite])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.dynamite, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playEquipment(.dynamite, player: "p1")
        ])
    }

    @Test func triggeringDynamite_withFlippedCardIsHearts_shouldPassInPlay() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withInPlay([.dynamite])
                    .withAbilities([.drawOnStartTurn])
                    .withAttributes([.flippedCards: 1, .startTurnCards: 2])
            }
            .withPlayer("p2")
            .withDeck(["c1-9♦️", "c2", "c3"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .draw,
            .passInPlay(.dynamite, target: "p2", player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func triggeringDynamite_withFlippedCardIsSpades_notLethal_shouldApplyDamageAndDiscardCard() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withInPlay([.dynamite])
                    .withAbilities([.drawOnStartTurn])
                    .withAttributes([.flippedCards: 1, .startTurnCards: 2])
                    .withHealth(4)
            }
            .withDeck(["c1-8♠️", "c2", "c3"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .draw,
            .damage(3, player: "p1"),
            .discardInPlay(.dynamite, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func triggeringDynamite_withFlippedCardIsSpades_lethal_shouldEliminate() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withInPlay([.jail, .dynamite])
                    .withAbilities([
                        .eliminateOnDamageLethal,
                        .discardCardsOnEliminated,
                        .nextTurnOnEliminated
                    ])
                    .withAttributes([
                        .flippedCards: 1,
                        .startTurnCards: 2
                    ])
                    .withHealth(3)
            }
            .withPlayer("p2") {
                $0.withAbilities([.drawOnStartTurn])
                    .withAttributes([.startTurnCards: 2])
            }
            .withPlayer("p3")
            .withDeck(["c1-8♠️", "c2", "c3"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .draw,
            .damage(3, player: "p1"),
            .eliminate(player: "p1"),
            .discardInPlay(.jail, player: "p1"),
            .discardInPlay(.dynamite, player: "p1"),
            .startTurn(player: "p2"),
            .drawDeck(player: "p2"),
            .drawDeck(player: "p2")
        ])
    }
     */
}
