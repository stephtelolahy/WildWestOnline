//
//  DynamiteTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct DynamiteTest {
    @Test func playDynamite_shouldEquip() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.dynamite])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.dynamite, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .equip(.dynamite, player: "p1")
        ])
    }

    @Test func triggeringDynamite_withFlippedCardIsHearts_shouldPassInPlay() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withDummyCards(["c2", "c3"])
            .withPlayer("p1") {
                $0.withInPlay([.dynamite])
                    .withAbilities([.draw2CardsOnTurnStarted])
                    .withDrawCards(1)
            }
            .withPlayer("p2")
            .withDeck(["c1-9♦️", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .draw(),
            .passInPlay(.dynamite, target: "p2", player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func triggeringDynamite_withFlippedCardIsSpades_notLethal_shouldApplyDamageAndDiscardCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withDummyCards(["c2", "c3"])
            .withPlayer("p1") {
                $0.withInPlay([.dynamite])
                    .withAbilities([.draw2CardsOnTurnStarted])
                    .withDrawCards(1)
                    .withHealth(4)
            }
            .withDeck(["c1-8♠️", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .draw(),
            .damage(3, player: "p1"),
            .discardInPlay(.dynamite, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func triggeringDynamite_withFlippedCardIsSpades_lethal_shouldEliminate() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withDummyCards(["c2", "c3", "c4"])
            .withPlayer("p1") {
                $0.withInPlay([.dynamite, "c4"])
                    .withAbilities([
                        .startTurnNextOnTurnEnded,
                        .eliminateOnDamageLethal,
                        .discardAllCardsOnEliminated,
                        .endTurnOnEliminated
                    ])
                    .withDrawCards(1)
                    .withHealth(3)
            }
            .withPlayer("p2") {
                $0.withAbilities([.draw2CardsOnTurnStarted])
            }
            .withPlayer("p3")
            .withDeck(["c1-8♠️", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .draw(),
            .damage(3, player: "p1"),
            .eliminate(player: "p1"),
            .discardInPlay(.dynamite, player: "p1"),
            .discardInPlay("c4", player: "p1"),
            .startTurn(player: "p2"),
            .drawDeck(player: "p2"),
            .drawDeck(player: "p2")
        ])
    }
}
