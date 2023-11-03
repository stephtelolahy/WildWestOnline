//
//  PaulRegretSpec.swift
//  
//
//  Created by Hugues Telolahy on 03/11/2023.
//

import Quick
import Nimble
import Game
import Inventory

final class PaulRegretSpec: QuickSpec {
    override func spec() {
        describe("PaulRegret") {
            it("should have mustang") {
                // Given
                let state = Setup.buildGame(figures: [.paulRegret],
                                            deck: (0..<10).map { "c\($0)" },
                                            cardRef: CardList.all)

                // When
                let player = state.player(.paulRegret)

                // Then
                expect(player.attributes[.mustang]) == 1
            }
        }
    }
}
