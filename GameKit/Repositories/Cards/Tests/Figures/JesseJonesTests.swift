//
//  JesseJonesTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

import CardsRepository
import GameCore
import XCTest

final class JesseJonesTests: XCTestCase {
    func test_jesseJones_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.jesseJones], deck: [], cards: CardList.all)

        // When
        let player = state.player(.jesseJones)

        // Then
        XCTAssertFalse(player.abilities.contains(.drawOnSetTurn))
    }

    func test_jesseJonesStartTurn_withNonEmptyDiscard_shouldDrawFirstCardFromDiscard() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.jesseJones])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDiscard(["c1"])
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .drawDiscard(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_jesseJonesStartTurn_withEmptyDiscard_shouldDrawCardsFromDeck() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.jesseJones])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
