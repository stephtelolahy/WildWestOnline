//
//  RoseDoolanTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore
@testable import CardLibraryLive

struct RoseDoolanTest {
    @Test func shouldDecrementDistanceToOthers() async throws {
        let state = GameSetup.buildGame(
            figures: [.roseDoolan],
            deck: [],
            cards: Cards.all.toDictionary,
            auras: []
        )

        let player = state.players.get(.roseDoolan)

        #expect(player.magnifying == 1)
    }
}
