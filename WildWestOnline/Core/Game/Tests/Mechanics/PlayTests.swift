//
//  PlayTests.swift
//  
//
//  Created by Hugues Telolahy on 05/01/2024.
//

@testable import GameCore
import XCTest

final class PlayTests: XCTestCase {
    func test_play_withNotPlayableCard_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .build()

        // When
        // Then
        let action = GameAction.preparePlay("c1", player: "p1")
        XCTAssertThrowsError(try GameState.reducer(state, action)) { error in
            XCTAssertEqual(error as? SequenceState.Error, .cardNotPlayable("c1"))
        }
    }

    func test_play_withPlayableCard_shouldApplyEffects() throws {
        // Given
        let card1 = Card.makeBuilder(name: "c1")
            .withRule {
                CardEffect.drawDeck
                    .on([.play])
            }
            .build()
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withAbilities(["c1"])
            }
            .withCards(["c1": card1])
            .withDeck(["c2"])
            .build()

        // When
        let action = GameAction.preparePlay("c1", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.sequence.queue, [
            .prepareEffect(.drawDeck, ctx: .init(sourceEvent: action, sourceActor: "p1", sourceCard: "c1"))
        ])
    }
}
