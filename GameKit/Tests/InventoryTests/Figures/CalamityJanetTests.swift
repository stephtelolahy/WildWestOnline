//
//  CalamityJanetTests.swift
//
//
//  Created by Hugues Telolahy on 20/11/2023.
//

import Game
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
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .effect(.shoot, ctx: .init(actor: "p1", card: .bang, event: action, target: "p2"))
            ], player: "p1"),
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
            .play(.missed, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .nothing
            ], player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    func TODOtest_calamityJanetBeingShot_holdingBang_shouldAskToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.bang])
                    .withAbilities([.activateCounterCardsOnShot])
                    .withFigure(.calamityJanet)
            }
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2", .bang])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .nothing
            ], player: "p1"),
            .chooseOne([
                .bang: .play(.bang, player: "p2"),
                .pass: .nothing
            ], player: "p2"),
            .play(.bang, player: "p2"),
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
                    .withAbilities([.activateCounterCardsOnShot])
                    .withFigure(.calamityJanet)
            }
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2", .missed])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .effect(.shoot, ctx: .init(actor: "p1", card: .bang, event: action, target: "p2"))
            ], player: "p1"),
            .chooseOne([
                .missed: .play(.missed, player: "p2"),
                .pass: .nothing
            ], player: "p2"),
            .play(.missed, player: "p2"),
            .discardPlayed(.missed, player: "p2"),
            .cancel(.damage(1, player: "p2"))
        ])
    }
}
