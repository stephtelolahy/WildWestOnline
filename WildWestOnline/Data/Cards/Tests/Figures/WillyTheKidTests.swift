//
//  WillyTheKidTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsData
import GameCore
import XCTest

final class WillyTheKidTests: XCTestCase {
    func test_WillyTheKid_shouldHaveUnlimitedBang() throws {
        // Given
        let state = Setup.buildGame(figures: [.willyTheKid], deck: [], cards: Cards.all)

        // When
        let player = state.player(.willyTheKid)

        // Then
        XCTAssertEqual(player.attributes[.bangsPerTurn], 0)
    }

    /*
    @Test func play_noLimitPerTurn_shouldAllowMultipleBang() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .withPlayedThisTurn([.bang: 1])
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.bang, player: "p1"),
            .choose("p2", player: "p1"),
            .shoot("p2", player: "p1"),
            .damage(1, player: "p2")
        ])
    }
    */
}
