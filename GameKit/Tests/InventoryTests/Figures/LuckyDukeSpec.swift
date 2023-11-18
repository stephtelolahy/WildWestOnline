//
//  LuckyDukeSpec.swift
//  
//
//  Created by Hugues Telolahy on 03/11/2023.
//

import Quick
import Nimble
import Game
import Inventory

final class LuckyDukeSpec: QuickSpec {
    override func spec() {
        describe("LuckyDuke") {
            it("should have two flipped cards") {
                // Given
                let state = Setup.buildGame(figures: [.luckyDuke], deck: [], cardRef: CardList.all)

                // When
                let player = state.player(.luckyDuke)

                // Then
                expect(player.attributes[.flippedCards]) == 2
            }
        }
    }
}
