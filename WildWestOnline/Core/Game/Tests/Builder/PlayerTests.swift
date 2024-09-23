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
    @Test func buildPlayer_byDefault_shouldHaveEmptyFigure() async throws {
        let sut = Player.makeBuilder()
            .build()
        #expect(sut.figure.isEmpty)
    }

    @Test func buildPlayer_byDefault_shouldNotHaveAttributes() async throws {
        let sut = Player.makeBuilder()
            .build()
        #expect(sut.attributes.isEmpty)
    }

    @Test func buildPlayer_withHand_shouldHaveHandCards() async throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // Then
        #expect(sut.field.hand["p1"] == ["c1", "c2"])
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
        #expect(sut.field.inPlay["p1"] == ["c1", "c2"])
    }

    @Test func buildPlayer_withAttributes_shouldHaveAttributes() async throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withAttributes([.remoteness: 1])
            .build()

        // Then
        #expect(sut.attributes[.remoteness] == 1)
    }
}
