//
//  JailTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

@testable import GameCore
import XCTest

final class JailTests: XCTestCase {
    func test_playingJail_againstAnyPlayer_shouldHandicap() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.jail])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.jail, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.jail, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .handicap(.jail, target: "p2", player: "p1")
        ])
    }

    func test_triggeringJail_flippedCardIsHearts_shouldEscapeFromJail() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withInPlay([.jail])
                    .withAbilities([.drawOnStartTurn])
                    .withAttributes([.flippedCards: 1, .startTurnCards: 2])
            }
            .withPlayer("p2")
            .withDeck(["c1-2♥️", "c2", "c3"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .startTurn(player: "p1"),
            .draw,
            .discardInPlay(.jail, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_triggeringJail_flippedCardIsSpades_shouldSkipTurn() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withInPlay([.jail])
                    .withAbilities([.drawOnStartTurn])
                    .withAttributes([.flippedCards: 1, .startTurnCards: 2])
            }
            .withPlayer("p2")
            .withDeck(["c1-A♠️", "c2", "c3"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .startTurn(player: "p1"),
            .draw,
            .cancel(
                .effect(
                    .repeat(.attr(.startTurnCards), effect: .drawDeck),
                    ctx: EffectContext(sourceEvent: .startTurn(player: "p1"), sourceActor: "p1", sourceCard: .drawOnStartTurn)
                )
            ),
            .discardInPlay(.jail, player: "p1"),
            .startTurn(player: "p2")
        ])
    }
}
