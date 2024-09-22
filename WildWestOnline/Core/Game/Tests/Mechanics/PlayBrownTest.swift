//
//  PlayBrownTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing

struct PlayBrownTest {
    @Test func playBrown() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        Issue.record("unimplemented")
    }
    /*
     func test_discardPlayed_shouldRemoveCardFromHand() throws {
         // Given
         let state = GameState.makeBuilder()
             .withPlayer("p1") {
                 $0.withHand(["c1", "c2"])
             }
             .build()

         // When
         let action = GameAction.playBrown("c1", player: "p1")
         let result = try GameState.reducer(state, action)

         // Then
         XCTAssertEqual(result.field.hand["p1"], ["c2"])
         
     */
}
