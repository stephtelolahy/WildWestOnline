//
//  InventoryTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import XCTest
import Bang

final class InventoryTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()

    func test_BangDefaultCards() throws {
        // Given
        // When
        let cards = inventory.getAll(.defaultAbility)
        
        // Assert
//        XCTAssertTrue(cards.contains { $0.name == "startTurn" })
        XCTAssertTrue(cards.contains { $0.name == "endTurn" })
    }

    func test_BangCollectibleCards() throws {
        // Given
        // When
        let cards = inventory.getAll(.collectible)
        
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
//        XCTAssertTrue(cards.contains { $0.name == "bang" })
        XCTAssertTrue(cards.contains { $0.name == "beer" })
        XCTAssertTrue(cards.contains { $0.name == "catBalou" })
//        XCTAssertTrue(cards.contains { $0.name == "duel" })
//        XCTAssertTrue(cards.contains { $0.name == "gatling" })
        XCTAssertTrue(cards.contains { $0.name == "generalStore" })
//        XCTAssertTrue(cards.contains { $0.name == "indians" })
//        XCTAssertTrue(cards.contains { $0.name == "missed" })
//        XCTAssertTrue(cards.contains { $0.name == "panic" })
        XCTAssertTrue(cards.contains { $0.name == "saloon" })
        XCTAssertTrue(cards.contains { $0.name == "stagecoach" })
        XCTAssertTrue(cards.contains { $0.name == "wellsFargo" })
    }
    
//    func test_BangCharacterCards() throws {
//        // Given
//        // When
//        let cards = inventory.getAll(.specialAbility)
//
//        // Assert
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
//    }

}
