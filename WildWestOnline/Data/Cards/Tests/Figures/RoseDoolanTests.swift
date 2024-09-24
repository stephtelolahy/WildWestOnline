//
//  RoseDoolanTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsData
import GameCore
import Testing

struct RoseDoolanTests {
    @Test func RoseDoolan_shouldDecrementDistanceToOthers() async throws {
        // Given
        let state = Setup.buildGame(
            figures: [.roseDoolan],
            deck: [],
            cards: CardsRepository().inventory.cards
        )

        // When
        let player = state.player(.roseDoolan)

        // Then
        #expect(player.attributes[.magnifying] == 1)
    }
}
