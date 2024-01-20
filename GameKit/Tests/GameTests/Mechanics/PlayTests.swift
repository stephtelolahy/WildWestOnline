//
//  PlayTests.swift
//  
//
//  Created by Hugues Telolahy on 05/01/2024.
//

@testable import Game
import XCTest

final class PlayTests: XCTestCase {
    func test_play_withNotPlayableCard_shouldThrowError() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .build()

        // When
        let action = GameAction.play("c1", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.error, .cardNotPlayable("c1"))
    }

    func test_play_withPlayableCard_shouldApplyEffects() {
        // Given
        let card1 = Card("c1") {
            CardEffect.nothing
                .on([.play])
        }
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withAbilities(["c1"])
            }
            .withCardRef(["c1": card1])
            .build()

        // When
        let action = GameAction.play("c1", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.sequence, [
            .effect(.nothing, ctx: .init(actor: "p1", card: "c1", event: action))
        ])
    }
}
