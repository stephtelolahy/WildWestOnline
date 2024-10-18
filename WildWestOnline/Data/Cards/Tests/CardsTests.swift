//
//  CardsTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsData
import Testing

struct CardsTests {
    // Given
    // When
    private let cards = CardsRepository().inventory.cards

    @Test func inventory_shouldContainCollectibleCards() async throws {
        // Then
        #expect(cards[.beer] != nil)
        #expect(cards[.saloon] != nil)
        #expect(cards[.stagecoach] != nil)
        #expect(cards[.wellsFargo] != nil)
        #expect(cards[.catBalou] != nil)
        #expect(cards[.panic] != nil)
        #expect(cards[.generalStore] != nil)
        #expect(cards[.bang] != nil)
        #expect(cards[.missed] != nil)
        #expect(cards[.gatling] != nil)
        #expect(cards[.indians] != nil)
        #expect(cards[.duel] != nil)
        #expect(cards[.barrel] != nil)
        #expect(cards[.dynamite] != nil)
        #expect(cards[.jail] != nil)
        #expect(cards[.mustang] != nil)
        #expect(cards[.remington] != nil)
        #expect(cards[.revCarabine] != nil)
        #expect(cards[.schofield] != nil)
        #expect(cards[.scope] != nil)
        #expect(cards[.volcanic] != nil)
        #expect(cards[.winchester] != nil)
    }

    @Test func inventory_shouldContainAbilities() async throws {
        // Then
        #expect(cards[.endTurn] != nil)
        #expect(cards[.drawOnStartTurn] != nil)
        #expect(cards[.eliminateOnDamageLethal] != nil)
        #expect(cards[.discardCardsOnEliminated] != nil)
        #expect(cards[.nextTurnOnEliminated] != nil)
        #expect(cards[.discardPreviousWeaponOnPlayWeapon] != nil)
        #expect(cards[.updateAttributesOnChangeInPlay] != nil)
    }

    @Test func inventory_shouldContainFigures() async throws {
        // Then
        #expect(cards[.willyTheKid] != nil)
        #expect(cards[.roseDoolan] != nil)
        #expect(cards[.paulRegret] != nil)
        #expect(cards[.jourdonnais] != nil)
        #expect(cards[.slabTheKiller] != nil)
        #expect(cards[.luckyDuke] != nil)
        #expect(cards[.calamityJanet] != nil)
        #expect(cards[.bartCassidy] != nil)
        #expect(cards[.elGringo] != nil)
        #expect(cards[.suzyLafayette] != nil)
        #expect(cards[.vultureSam] != nil)
        #expect(cards[.sidKetchum] != nil)
        #expect(cards[.blackJack] != nil)
        #expect(cards[.kitCarlson] != nil)
        #expect(cards[.jesseJones] != nil)
        #expect(cards[.pedroRamirez] != nil)
    }
}
