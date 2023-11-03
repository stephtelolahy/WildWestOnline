//
//  WillyTheKidSpec.swift
//  
//
//  Created by Hugues Telolahy on 28/10/2023.
//

import Quick
import Nimble
import Game
import Inventory

final class WillyTheKidSpec: QuickSpec {
    override func spec() {
        describe("WillyTheKid") {
            it("should have unlimited bang") {
                // Given
                let state = Setup.buildGame(figures: [.willyTheKid],
                                            deck: (0..<10).map { "c\($0)" },
                                            cardRef: CardList.all)

                // When
                let player = state.player(.willyTheKid)

                // Then
                expect(player.attributes[.bangsPerTurn]) == 0
            }
        }
    }
}
