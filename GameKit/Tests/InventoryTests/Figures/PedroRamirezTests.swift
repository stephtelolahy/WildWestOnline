//
//  PedroRamirezTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 13/11/2023.
//

import XCTest
import Game
import Inventory

final class PedroRamirezTests: XCTestCase {
    
    func test_pedroRamirez_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.pedroRamirez],
                                    deck: (0..<10).map { "c\($0)" },
                                    cardRef: CardList.all)
        
        // When
        let player = state.player(.pedroRamirez)
        
        // Then
        XCTAssertNil(player.attributes[.drawOnSetTurn])
    }
    
    func test_pedroRamirezStartTurn_withAnotherPlayerHoldingCard_ShouldAskDrawFirstCardFromPlayer() throws {
        XCTFail()
    }
    
    func test_pedroRamirezStartTurn_withthoutAnotherPlayerHoldingCard_ShouldDrawCardsFromDeck() throws {
        XCTFail()
    }
}
