//
//  RoseDoolanSpec.swift
//  
//
//  Created by Hugues Telolahy on 28/10/2023.
//

import Quick
import Nimble
import Game
import Inventory

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
