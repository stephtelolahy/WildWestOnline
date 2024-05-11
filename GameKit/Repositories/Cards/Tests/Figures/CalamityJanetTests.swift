//
//  CalamityJanetTests.swift
//
//
//  Created by Hugues Telolahy on 20/11/2023.
//

import GameCore
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
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
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
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.play(.missed, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.missed, player: "p1"),
            .discardPlayed(.missed, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
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
                    .withAbilities([.playCounterCardsOnShot])
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
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.counterCard, options: [.bang, .pass], player: "p2"),
            .choose(.bang, player: "p2"),
            .play(.bang, player: "p2"),
            .discardPlayed(.bang, player: "p2"),
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
                    .withAbilities([.playCounterCardsOnShot])
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
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.counterCard, options: [.missed, .pass], player: "p2"),
            .choose(.missed, player: "p2"),
            .play(.missed, player: "p2"),
            .discardPlayed(.missed, player: "p2"),
            .cancel(.damage(1, player: "p2"))
        ])
    }
}
