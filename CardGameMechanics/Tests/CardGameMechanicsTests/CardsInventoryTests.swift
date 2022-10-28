//
//  CardsInventoryTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 29/10/2022.
//

import CardGameCore
import CardGameMechanics
import XCTest

final class CardsInventoryTests: XCTestCase {
    
    func test_BangInnerCards() throws {
        // Given
        // When
        let cards = Cards.getAll(type: .inner)
        
        // Assert
        XCTAssertTrue(cards.contains { $0.name == "startTurn" })
        XCTAssertTrue(cards.contains { $0.name == "endTurn" })
    }

    func test_BangCollectibleCards() throws {
        // Given
        // When
        let cards = Cards.getAll(type: .collectible)
        
        // Assert
//        XCTAssertTrue(cards.contains { $0.name == "barrel" })
//        XCTAssertTrue(cards.contains { $0.name == "dynamite" })
//        XCTAssertTrue(cards.contains { $0.name == "jail" })
//        XCTAssertTrue(cards.contains { $0.name == "mustang" })
//        XCTAssertTrue(cards.contains { $0.name == "remington" })
//        XCTAssertTrue(cards.contains { $0.name == "revCarabine" })
//        XCTAssertTrue(cards.contains { $0.name == "schofield" })
//        XCTAssertTrue(cards.contains { $0.name == "scope" })
//        XCTAssertTrue(cards.contains { $0.name == "volcanic" })
//        XCTAssertTrue(cards.contains { $0.name == "winchester" })
        XCTAssertTrue(cards.contains { $0.name == "bang" })
        XCTAssertTrue(cards.contains { $0.name == "beer" })
        XCTAssertTrue(cards.contains { $0.name == "catBalou" })
        XCTAssertTrue(cards.contains { $0.name == "duel" })
        XCTAssertTrue(cards.contains { $0.name == "gatling" })
//        XCTAssertTrue(cards.contains { $0.name == "generalstore" })
        XCTAssertTrue(cards.contains { $0.name == "indians" })
        XCTAssertTrue(cards.contains { $0.name == "missed" })
        XCTAssertTrue(cards.contains { $0.name == "panic" })
        XCTAssertTrue(cards.contains { $0.name == "saloon" })
        XCTAssertTrue(cards.contains { $0.name == "stagecoach" })
        XCTAssertTrue(cards.contains { $0.name == "wellsFargo" })
    }
    
    func test_BangCharacterCards() throws {
        // Given
        // When
//        let cards = Cards.getAll(type: .character)
        
        // Assert
//        XCTAssertTrue(cards.contains { $0.name == "bartCassidy" })
//        XCTAssertTrue(cards.contains { $0.name == "blackJack" })
//        XCTAssertTrue(cards.contains { $0.name == "calamityJanet" })
//        XCTAssertTrue(cards.contains { $0.name == "elGringo" })
//        XCTAssertTrue(cards.contains { $0.name == "jesseJones" })
//        XCTAssertTrue(cards.contains { $0.name == "jourdonnais" })
//        XCTAssertTrue(cards.contains { $0.name == "kitCarlson" })
//        XCTAssertTrue(cards.contains { $0.name == "luckyDuke" })
//        XCTAssertTrue(cards.contains { $0.name == "paulRegret" })
//        XCTAssertTrue(cards.contains { $0.name == "pedroRamirez" })
//        XCTAssertTrue(cards.contains { $0.name == "roseDoolan" })
//        XCTAssertTrue(cards.contains { $0.name == "sidKetchum" })
//        XCTAssertTrue(cards.contains { $0.name == "slabTheKiller" })
//        XCTAssertTrue(cards.contains { $0.name == "suzyLafayette" })
//        XCTAssertTrue(cards.contains { $0.name == "vultureSam" })
//        XCTAssertTrue(cards.contains { $0.name == "willyTheKid" })
    }
}
