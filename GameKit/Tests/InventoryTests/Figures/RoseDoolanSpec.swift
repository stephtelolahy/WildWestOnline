//
//  RoseDoolanSpec.swift
//  
//
//  Created by Hugues Telolahy on 28/10/2023.
//

import Game
import Inventory
import Nimble
import Quick

final class RoseDoolanSpec: QuickSpec {
    override func spec() {
        describe("RoseDoolan") {
            it("should have scope") {
                // Given
                let state = Setup.buildGame(figures: [.roseDoolan], deck: [], cardRef: CardList.all)

                // When
                let player = state.player(.roseDoolan)

                // Then
                expect(player.attributes[.scope]) == 1
            }
        }
    }
}
