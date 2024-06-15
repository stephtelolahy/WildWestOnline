//
//  SidKetchumTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class SidKetchumTests: XCTestCase {
    func test_playing_SidKetchum_havingTwoCards_shouldDiscardThemAndGainHealth() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHand(["c1", "c2"])
                    .withHealth(1)
            }
            .build()

        // When
        let action = GameAction.play(.sidKetchum, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["c1", "c2"])

        // Then
        XCTAssertEqual(result, [
            .play(.sidKetchum, player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c1", "c2"], player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c2"], player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    func test_playing_SidKetchum_havingThreeCards_shouldDiscardTwoCardsAndGainHealth() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHand(["c1", "c2", "c3"])
                    .withHealth(1)
            }
            .build()

        // When
        let action = GameAction.play(.sidKetchum, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["c1", "c2"])

        // Then
        XCTAssertEqual(result, [
            .play(.sidKetchum, player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c1", "c2", "c3"], player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c2", "c3"], player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    func test_playing_SidKetchum_withoutCard_shouldThrowError() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHealth(1)
            }
            .build()

        // When
        let action = GameAction.play(.sidKetchum, player: "p1")
        let (_, error) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .noCard(.selectHand))
    }

    func test_playing_SidKetchum_alreadyMaxHealth_shouldThrowError() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHand(["c1", "c2"])
                    .withHealth(4)
            }
            .build()

        // When
        let action = GameAction.play(.sidKetchum, player: "p1")
        let (_, error) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .playerAlreadyMaxHealth("p1"))
    }
}
