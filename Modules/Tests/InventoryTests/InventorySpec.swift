//
//  InventorySpec.swift
//  
//
//  Created by Hugues Telolahy on 04/04/2023.
//
import Foundation
import Quick
import Nimble
import Inventory

final class InventorySpec: QuickSpec {
    override func spec() {
        describe("inventory") {
            it("should contain all collectible cards") {
                // Given
                // When
                let cards = CardList.all

                // Then
                expect(cards[.beer]) != nil
                expect(cards[.saloon]) != nil
                expect(cards[.stagecoach]) != nil
                expect(cards[.wellsFargo]) != nil
                expect(cards[.catBalou]) != nil
                expect(cards[.panic]) != nil
                expect(cards[.generalStore]) != nil
                expect(cards[.bang]) != nil
                expect(cards[.missed]) != nil
                expect(cards[.gatling]) != nil
                expect(cards[.indians]) != nil
                expect(cards[.duel]) != nil
                expect(cards[.barrel]) != nil
                expect(cards[.dynamite]) != nil
                expect(cards[.jail]) != nil
//                expect(cards[.mustang]) != nil
//                expect(cards[.remington]) != nil
//                expect(cards[.revCarabine]) != nil
//                expect(cards[.schofield]) != nil
//                expect(cards[.scope]) != nil
//                expect(cards[.volcanic]) != nil
//                expect(cards[.winchester]) != nil
            }

            it("should contain all abilities") {
                // Given
                // When
                let cards = CardList.all

                // Then
                expect(cards[.endTurn]) != nil
                expect(cards[.drawOnSetTurn]) != nil
                expect(cards[.eliminateOnLooseLastHealth]) != nil
            }
        }
    }
}
