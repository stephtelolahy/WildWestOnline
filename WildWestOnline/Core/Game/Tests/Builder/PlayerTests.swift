//
//  PlayerTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Foundation
import GameCore
import Testing

struct PlayerTests {
    @Test func buildPlayer_withHand_shouldHaveHandCards() async throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // Then
        #expect(sut.player("p1").hand == ["c1", "c2"])
    }

    @Test func buildPlayer_withInPlay_shouldHaveInPlayCards() async throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withInPlay(["c1", "c2"])
            }
            .build()

        // Then
        #expect(sut.player("p1").inPlay == ["c1", "c2"])
    }
}
