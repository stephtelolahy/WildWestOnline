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
                let state = Setup.buildGame(figures: [.roseDoolan],
                                            deck: (0..<10).map { "c\($0)" },
                                            cardRef: CardList.all)

                // When
                let player = state.player(.roseDoolan)

                // Then
                expect(player.attributes[.scope]) == 1
            }
        }
    }
}
