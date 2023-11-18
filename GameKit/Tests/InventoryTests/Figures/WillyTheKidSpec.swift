//
//  WillyTheKidSpec.swift
//  
//
//  Created by Hugues Telolahy on 28/10/2023.
//

import Game
import Inventory
import Nimble
import Quick

final class WillyTheKidSpec: QuickSpec {
    override func spec() {
        describe("WillyTheKid") {
            it("should have unlimited bang") {
                // Given
                let state = Setup.buildGame(figures: [.willyTheKid], deck: [], cardRef: CardList.all)

                // When
                let player = state.player(.willyTheKid)

                // Then
                expect(player.attributes[.bangsPerTurn]) == 0
            }
        }
    }
}
