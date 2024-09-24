//
//  SaloonTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct SaloonTests {
    @Test func playSaloon_withSomePlayersDamaged_shouldHealOneLifePoint() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.saloon])
                    .withHealth(4)
                    .withAttributes([.maxHealth: 4])
            }
            .withPlayer("p2") {
                $0.withHealth(2)
                    .withAttributes([.maxHealth: 4])
            }
            .withPlayer("p3") {
                $0.withHealth(3)
                    .withAttributes([.maxHealth: 4])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.saloon, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playBrown(.saloon, player: "p1"),
            .heal(1, player: "p2"),
            .heal(1, player: "p3")
        ])
    }

    @Test func playSaloon_withoutPlayerDamaged_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.saloon])
                    .withHealth(4)
                    .withAttributes([.maxHealth: 4])
            }
            .withPlayer("p2") {
                $0.withHealth(3)
                    .withAttributes([.maxHealth: 3])
            }
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.saloon, player: "p1")
        await #expect(throws: ArgPlayer.Error.noPlayer(.damaged)) {
            try await dispatch(action, state: state)
        }
    }
}
