//
//  JailTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
// swiftlint:disable no_magic_numbers

import Game
import XCTest

final class JailTests: XCTestCase {
    func test_playingJail_againstAnyPlayer_shouldHandicap() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.jail])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.jail, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.jail, player: "p1"),
            .chooseOne([
                "p2": .handicap(.jail, target: "p2", player: "p1")
            ], player: "p1"),
            .handicap(.jail, target: "p2", player: "p1")
        ])
    }

    func test_playingJail_againstSheriff_shouldNotBeAsked() {
        // Given
        // When
        // Then
#warning("unimplemented")
    }

    func test_triggeringJail_flippedCardIsHearts_shouldEscapeFromJail() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withInPlay([.jail])
                    .withAbilities([.drawOnSetTurn])
                    .withAttributes([.flippedCards: 1, .startTurnCards: 2])
            }
            .withPlayer("p2")
            .withDeck(["c1-2♥️", "c2", "c3"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .draw,
            .discardInPlay(.jail, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_triggeringJail_flippedCardIsSpades_shouldSkipTurn() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withInPlay([.jail])
                    .withAbilities([.drawOnSetTurn])
                    .withAttributes([.flippedCards: 1, .startTurnCards: 2])
            }
            .withPlayer("p2")
            .withDeck(["c1-A♠️", "c2", "c3"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .draw,
            .cancel(.effect(.repeat(.attr(.startTurnCards), effect: .drawDeck), ctx: EffectContext(actor: "p1", card: .drawOnSetTurn, event: .setTurn(player: "p1")))),
            .discardInPlay(.jail, player: "p1"),
            .setTurn(player: "p2")
        ])
    }
}
