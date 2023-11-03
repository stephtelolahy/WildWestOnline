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
                expect(cards[.mustang]) != nil
                expect(cards[.remington]) != nil
                expect(cards[.revCarabine]) != nil
                expect(cards[.schofield]) != nil
                expect(cards[.scope]) != nil
                expect(cards[.volcanic]) != nil
                expect(cards[.winchester]) != nil
            }

            it("should contain all abilities") {
                // Given
                // When
                let cards = CardList.all

                // Then
                expect(cards[.endTurn]) != nil
                expect(cards[.drawOnSetTurn]) != nil
                expect(cards[.eliminateOnDamageLethal]) != nil
                expect(cards[.discardCardsOnEliminated]) != nil
                expect(cards[.nextTurnOnEliminated]) != nil
                expect(cards[.discardPreviousWeaponOnPlayWeapon]) != nil
                expect(cards[.evaluateAttributesOnUpdateInPlay]) != nil
            }

            it("should contain all figures") {
                // Given
                // When
                let cards = CardList.all

                // Then
                expect(cards[.willyTheKid]) != nil
                expect(cards[.roseDoolan]) != nil
                expect(cards[.paulRegret]) != nil
                expect(cards[.jourdonnais]) != nil
                expect(cards[.slabTheKiller]) != nil
                expect(cards[.luckyDuke]) != nil
                expect(cards[.calamityJanet]) != nil
                expect(cards[.bartCassidy]) != nil
                expect(cards[.elGringo]) != nil
                expect(cards[.suzyLafayette]) != nil
                expect(cards[.vultureSam]) != nil
                expect(cards[.sidKetchum]) != nil
                expect(cards[.blackJack]) != nil
                expect(cards[.kitCarlson]) != nil
                expect(cards[.jesseJones]) != nil
                expect(cards[.pedroRamirez]) != nil
            }
        }
    }
}
