//
//  DynamiteTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class DynamiteTests: XCTestCase {
    func test_playDynamite_shouldEquip() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.dynamite])
            }
            .build()

        // When
        let action = GameAction.play(.dynamite, player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.dynamite, player: "p1"),
            .equip(.dynamite, player: "p1")
        ])
    }

    func test_triggeringDynamite_withFlippedCardIsHearts_shouldPassInPlay() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withInPlay([.dynamite])
                    .withAbilities([.drawOnSetTurn])
                    .withAttributes([.flippedCards: 1, .startTurnCards: 2])
            }
            .withPlayer("p2")
            .withDeck(["c1-9♦️", "c2", "c3"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .draw,
            .passInPlay(.dynamite, target: "p2", player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_triggeringDynamite_withFlippedCardIsSpades_notLethal_shouldApplyDamageAndDiscardCard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withInPlay([.dynamite])
                    .withAbilities([.drawOnSetTurn])
                    .withAttributes([.flippedCards: 1, .startTurnCards: 2])
                    .withHealth(4)
            }
            .withDeck(["c1-8♠️", "c2", "c3"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .draw,
            .damage(3, player: "p1"),
            .discardInPlay(.dynamite, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_triggeringDynamite_withFlippedCardIsSpades_lethal_shouldEliminate() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
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
                $0.withAbilities([.drawOnSetTurn])
                    .withAttributes([.startTurnCards: 2])
            }
            .withPlayer("p3")
            .withDeck(["c1-8♠️", "c2", "c3"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .draw,
            .damage(3, player: "p1"),
            .eliminate(player: "p1"),
            .discardInPlay(.jail, player: "p1"),
            .discardInPlay(.dynamite, player: "p1"),
            .setTurn(player: "p2"),
            .drawDeck(player: "p2"),
            .drawDeck(player: "p2")
        ])
    }
}
