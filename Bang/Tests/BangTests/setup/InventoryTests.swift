//
//  InventoryTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
// swiftlint:disable function_body_length type_body_length

import XCTest
@testable import Bang

final class InventoryTests: XCTestCase {
    
    private let sut: Inventory = InventoryImpl()
    
    func test_BangDefaultAbilities() throws {
        // Given
        // When
        let cards = sut.getAbilities()
        
        // Assert
        XCTAssertTrue(cards.contains { $0.name == .endTurn })
        XCTAssertTrue(cards.contains { $0.name == .startTurn })
        XCTAssertTrue(cards.contains { $0.name == .leaveGame })
        XCTAssertTrue(cards.contains { $0.name == .gameOver })
    }
    
    func test_BangCollectibleCards() throws {
        // Given
        // When
        let cards = sut.getCollectibles()
        
        // Assert
        XCTAssertTrue(cards.contains { $0.name == .barrel })
        XCTAssertTrue(cards.contains { $0.name == .dynamite })
        XCTAssertTrue(cards.contains { $0.name == .jail })
        XCTAssertTrue(cards.contains { $0.name == .mustang })
        XCTAssertTrue(cards.contains { $0.name == .remington })
        XCTAssertTrue(cards.contains { $0.name == .revCarabine })
        XCTAssertTrue(cards.contains { $0.name == .schofield })
        XCTAssertTrue(cards.contains { $0.name == .scope })
        XCTAssertTrue(cards.contains { $0.name == .volcanic })
        XCTAssertTrue(cards.contains { $0.name == .winchester })
        XCTAssertTrue(cards.contains { $0.name == .bang })
        XCTAssertTrue(cards.contains { $0.name == .beer })
        XCTAssertTrue(cards.contains { $0.name == .catBalou })
        XCTAssertTrue(cards.contains { $0.name == .duel })
        XCTAssertTrue(cards.contains { $0.name == .gatling })
        XCTAssertTrue(cards.contains { $0.name == .generalStore })
        XCTAssertTrue(cards.contains { $0.name == .indians })
        XCTAssertTrue(cards.contains { $0.name == .missed })
        XCTAssertTrue(cards.contains { $0.name == .panic })
        XCTAssertTrue(cards.contains { $0.name == .saloon })
        XCTAssertTrue(cards.contains { $0.name == .stagecoach })
        XCTAssertTrue(cards.contains { $0.name == .wellsFargo })
    }
    
    func test_BangFigureCards() throws {
        // Given
        // When
        let cards = sut.getFigures()
        
        // Assert
        XCTAssertTrue(cards.contains { $0.name == .bartCassidy })
        XCTAssertTrue(cards.contains { $0.name == .blackJack })
        XCTAssertTrue(cards.contains { $0.name == .calamityJanet })
        XCTAssertTrue(cards.contains { $0.name == .elGringo })
        XCTAssertTrue(cards.contains { $0.name == .jesseJones })
        XCTAssertTrue(cards.contains { $0.name == .jourdonnais })
        XCTAssertTrue(cards.contains { $0.name == .kitCarlson })
        XCTAssertTrue(cards.contains { $0.name == .luckyDuke })
        XCTAssertTrue(cards.contains { $0.name == .paulRegret })
        XCTAssertTrue(cards.contains { $0.name == .pedroRamirez })
        XCTAssertTrue(cards.contains { $0.name == .roseDoolan })
        XCTAssertTrue(cards.contains { $0.name == .sidKetchum })
        XCTAssertTrue(cards.contains { $0.name == .slabTheKiller })
        XCTAssertTrue(cards.contains { $0.name == .suzyLafayette })
        XCTAssertTrue(cards.contains { $0.name == .vultureSam })
        XCTAssertTrue(cards.contains { $0.name == .willyTheKid })
    }
    
    func test_BangCardSets() throws {
        // Given
        // When
        let cards = sut.getDeck()
        
        // Assert
        XCTAssertTrue(cards.contains { $0.name == .barrel && $0.value == "Q♠️" })
        XCTAssertTrue(cards.contains { $0.name == .barrel && $0.value == "K♠️" })
        XCTAssertTrue(cards.contains { $0.name == .dynamite && $0.value == "2♥️" })
        XCTAssertTrue(cards.contains { $0.name == .jail && $0.value == "J♠️" })
        XCTAssertTrue(cards.contains { $0.name == .jail && $0.value == "4♥️" })
        XCTAssertTrue(cards.contains { $0.name == .jail && $0.value == "10♠️" })
        XCTAssertTrue(cards.contains { $0.name == .mustang && $0.value == "8♥️" })
        XCTAssertTrue(cards.contains { $0.name == .mustang && $0.value == "9♥️" })
        XCTAssertTrue(cards.contains { $0.name == .remington && $0.value == "K♣️" })
        XCTAssertTrue(cards.contains { $0.name == .revCarabine && $0.value == "A♣️" })
        XCTAssertTrue(cards.contains { $0.name == .schofield && $0.value == "J♣️" })
        XCTAssertTrue(cards.contains { $0.name == .schofield && $0.value == "Q♣️" })
        XCTAssertTrue(cards.contains { $0.name == .schofield && $0.value == "K♠️" })
        XCTAssertTrue(cards.contains { $0.name == .scope && $0.value == "A♠️" })
        XCTAssertTrue(cards.contains { $0.name == .volcanic && $0.value == "10♠️" })
        XCTAssertTrue(cards.contains { $0.name == .volcanic && $0.value == "10♣️" })
        XCTAssertTrue(cards.contains { $0.name == .winchester && $0.value == "8♠️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "A♠️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "2♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "3♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "4♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "5♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "6♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "7♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "8♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "9♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "10♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "J♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "Q♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "K♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "A♦️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "2♣️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "3♣️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "4♣️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "5♣️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "6♣️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "7♣️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "8♣️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "9♣️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "Q♥️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "K♥️" })
        XCTAssertTrue(cards.contains { $0.name == .bang && $0.value == "A♥️" })
        XCTAssertTrue(cards.contains { $0.name == .beer && $0.value == "6♥️" })
        XCTAssertTrue(cards.contains { $0.name == .beer && $0.value == "7♥️" })
        XCTAssertTrue(cards.contains { $0.name == .beer && $0.value == "8♥️" })
        XCTAssertTrue(cards.contains { $0.name == .beer && $0.value == "9♥️" })
        XCTAssertTrue(cards.contains { $0.name == .beer && $0.value == "10♥️" })
        XCTAssertTrue(cards.contains { $0.name == .beer && $0.value == "J♥️" })
        XCTAssertTrue(cards.contains { $0.name == .catBalou && $0.value == "K♥️" })
        XCTAssertTrue(cards.contains { $0.name == .catBalou && $0.value == "9♦️" })
        XCTAssertTrue(cards.contains { $0.name == .catBalou && $0.value == "10♦️" })
        XCTAssertTrue(cards.contains { $0.name == .catBalou && $0.value == "J♦️" })
        XCTAssertTrue(cards.contains { $0.name == .duel && $0.value == "Q♦️" })
        XCTAssertTrue(cards.contains { $0.name == .duel && $0.value == "J♠️" })
        XCTAssertTrue(cards.contains { $0.name == .duel && $0.value == "8♣️" })
        XCTAssertTrue(cards.contains { $0.name == .gatling && $0.value == "10♥️" })
        XCTAssertTrue(cards.contains { $0.name == .generalStore && $0.value == "9♣️" })
        XCTAssertTrue(cards.contains { $0.name == .generalStore && $0.value == "Q♠️" })
        XCTAssertTrue(cards.contains { $0.name == .indians && $0.value == "K♦️" })
        XCTAssertTrue(cards.contains { $0.name == .indians && $0.value == "A♦️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "10♣️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "J♣️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "Q♣️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "K♣️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "A♣️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "2♠️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "3♠️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "4♠️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "5♠️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "6♠️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "7♠️" })
        XCTAssertTrue(cards.contains { $0.name == .missed && $0.value == "8♠️" })
        XCTAssertTrue(cards.contains { $0.name == .panic && $0.value == "J♥️" })
        XCTAssertTrue(cards.contains { $0.name == .panic && $0.value == "Q♥️" })
        XCTAssertTrue(cards.contains { $0.name == .panic && $0.value == "A♥️" })
        XCTAssertTrue(cards.contains { $0.name == .panic && $0.value == "8♦️" })
        XCTAssertTrue(cards.contains { $0.name == .saloon && $0.value == "5♥️" })
        XCTAssertTrue(cards.filter { $0.name == .stagecoach && $0.value == "9♠️" }.count == 2)
        XCTAssertTrue(cards.contains { $0.name == .wellsFargo && $0.value == "3♥️" })
    }
}
