//
//  CardsTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsData
import XCTest

final class CardsTests: XCTestCase {
    // Given
    // When
    private let cards = Cards.all

    func test_inventory_shouldContainCollectibleCards() throws {
        // Then
        XCTAssertNotNil(cards[.beer])
        XCTAssertNotNil(cards[.saloon])
        XCTAssertNotNil(cards[.stagecoach])
        XCTAssertNotNil(cards[.wellsFargo])
        XCTAssertNotNil(cards[.catBalou])
        XCTAssertNotNil(cards[.panic])
        XCTAssertNotNil(cards[.generalStore])
        XCTAssertNotNil(cards[.bang])
        XCTAssertNotNil(cards[.missed])
        XCTAssertNotNil(cards[.gatling])
        XCTAssertNotNil(cards[.indians])
        XCTAssertNotNil(cards[.duel])
        XCTAssertNotNil(cards[.barrel])
        XCTAssertNotNil(cards[.dynamite])
        XCTAssertNotNil(cards[.jail])
        XCTAssertNotNil(cards[.mustang])
        XCTAssertNotNil(cards[.remington])
        XCTAssertNotNil(cards[.revCarabine])
        XCTAssertNotNil(cards[.schofield])
        XCTAssertNotNil(cards[.scope])
        XCTAssertNotNil(cards[.volcanic])
        XCTAssertNotNil(cards[.winchester])
    }

    func test_inventory_shouldContainAbilities() throws {
        // Then
        XCTAssertNotNil(cards[.endTurn])
        XCTAssertNotNil(cards[.drawOnStartTurn])
        XCTAssertNotNil(cards[.eliminateOnDamageLethal])
        XCTAssertNotNil(cards[.discardCardsOnEliminated])
        XCTAssertNotNil(cards[.nextTurnOnEliminated])
        XCTAssertNotNil(cards[.discardPreviousWeaponOnPlayWeapon])
        XCTAssertNotNil(cards[.updateAttributesOnChangeInPlay])
    }

    func test_inventory_shouldContainFigures() throws {
        // Then
        XCTAssertNotNil(cards[.willyTheKid])
        XCTAssertNotNil(cards[.roseDoolan])
        XCTAssertNotNil(cards[.paulRegret])
        XCTAssertNotNil(cards[.jourdonnais])
        XCTAssertNotNil(cards[.slabTheKiller])
        XCTAssertNotNil(cards[.luckyDuke])
        XCTAssertNotNil(cards[.calamityJanet])
        XCTAssertNotNil(cards[.bartCassidy])
        XCTAssertNotNil(cards[.elGringo])
        XCTAssertNotNil(cards[.suzyLafayette])
        XCTAssertNotNil(cards[.vultureSam])
        XCTAssertNotNil(cards[.sidKetchum])
        XCTAssertNotNil(cards[.blackJack])
        XCTAssertNotNil(cards[.kitCarlson])
        XCTAssertNotNil(cards[.jesseJones])
        XCTAssertNotNil(cards[.pedroRamirez])
    }
}
