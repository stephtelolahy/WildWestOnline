//
//  PreparePlayTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing

struct PreparePlayTest {
    @Test func preparePlay() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        Issue.record("unimplemented")
    }

    /*
    @Test func play_withNotPlayableCard_shouldThrowError() async throws {
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
            #expect(error as? SequenceState.Error == .cardNotPlayable("c1"))
        }
    }

    @Test func play_withPlayableCard_shouldApplyEffects() async throws {
        // Given
        let card1 = Card(name: "c1")
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
     */
}
