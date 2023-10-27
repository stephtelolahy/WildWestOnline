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
            it("should have scope and maxHealth of 4") {
                // Given
                let sut = CardList.all[.roseDoolan]!

                // When
                // Then
                expect(sut.attributes) == [
                    .scope: 1,
                    .maxHealth: 4
                ]
            }
        }
    }
}
