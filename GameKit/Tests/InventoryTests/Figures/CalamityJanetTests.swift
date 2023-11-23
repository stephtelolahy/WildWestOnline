//
//  CalamityJanetTests.swift
//
//
//  Created by Hugues Telolahy on 20/11/2023.
//

import Game
import Inventory
import XCTest

final class CalamityJanetTests: XCTestCase {
    func test_calamityJanetPlayingBang_shouldPlayAsBang() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.bangsPerTurn: 1, .weapon: 1])
                    .withHand([.bang])
                    .withFigure(.calamityJanet)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .chooseOne(player: "p1", options: [
                "p2": .playImmediate(.bang, target: "p2", player: "p1")
            ]),
            .playImmediate(.bang, target: "p2", player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    func test_calamityJanetPlayingMissed_shouldPlayAsBang() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.bangsPerTurn: 1, .weapon: 1])
                    .withHand([.missed])
                    .withFigure(.calamityJanet)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.missed, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .chooseOne(player: "p1", options: [
                "p2": .playImmediate(.missed, target: "p2", player: "p1")
            ]),
            .playImmediate(.missed, target: "p2", player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    func test_calamityJanetBeingShot_holdingBang_shouldAskToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.bang])
                    .withAttributes([.activateCounterCardsOnShot: 0])
                    .withFigure(.calamityJanet)
            }
            .build()

        // When
        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: [.bang])

        // Then
        XCTAssertEqual(result, [
            .playImmediate(.bang, target: "p2", player: "p1"),
            .chooseOne(player: "p2", options: [
                .bang: .play(.bang, player: "p2"),
                .pass: .group([])
            ]),
            .playImmediate(.bang, player: "p2"),
            .cancel(.damage(1, player: "p2"))
        ])
    }

    func test_calamityJanetBeingShot_holdingMissed_shouldAskToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withAttributes([.activateCounterCardsOnShot: 0])
                    .withFigure(.calamityJanet)
            }
            .build()

        // When
        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: [.missed])

        // Then
        XCTAssertEqual(result, [
            .playImmediate(.bang, target: "p2", player: "p1"),
            .chooseOne(player: "p2", options: [
                .missed: .play(.missed, player: "p2"),
                .pass: .group([])
            ]),
            .playImmediate(.missed, player: "p2"),
            .cancel(.damage(1, player: "p2"))
        ])
    }
}
