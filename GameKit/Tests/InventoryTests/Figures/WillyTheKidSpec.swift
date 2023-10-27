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
            it("should have unlimited bang and maxHealth of 4") {
                // Given
                let sut = CardList.all[.willyTheKid]!

                // When
                // Then
                expect(sut.attributes) == [
                    .bangsPerTurn: 0,
                    .maxHealth: 4
                ]
            }
        }
    }
}
