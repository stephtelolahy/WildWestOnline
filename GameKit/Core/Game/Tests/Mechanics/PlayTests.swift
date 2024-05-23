//
//  PlayTests.swift
//  
//
//  Created by Hugues Telolahy on 05/01/2024.
//

@testable import GameCore
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
        let card1 = Card.makeBuilder(name: "c1")
            .withRule {
                CardEffect.nothing
                    .on([.play])
            }
            .build()
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withAbilities(["c1"])
            }
            .withCards(["c1": card1])
            .build()

        // When
        let action = GameAction.play("c1", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.sequence, [
            .effect(.nothing, ctx: .init(sourceEvent: action, sourceActor: "p1", sourceCard: "c1"))
        ])
    }
}
