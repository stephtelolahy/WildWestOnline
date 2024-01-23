//
//  GamePlayStateTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 23/01/2024.
//
// swiftlint:disable no_magic_numbers

import Game
import GameUI
import Inventory
import XCTest

final class GamePlayStateTests: XCTestCase {
    func test_buildGamePlaystate() {
        // Given
        let sut = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withFigure(.willyTheKid)
                    .withHealth(1)
                    .withAttributes([.maxHealth: 3])
                    .withAbilities([.endTurn, .willyTheKid])
                    .withHand([.bang, .gatling, .schofield, .mustang, .barrel, .beer])
                    .withInPlay([.saloon, .barrel])
            }
            .withPlayer("p2") {
                $0.withFigure(.bartCassidy)
                    .withHealth(3)
                    .withAttributes([.maxHealth: 4])
            }
            .withActive([.bang, .mustang, .barrel, .beer, .endTurn], player: "p1")
            .withChooseOne(.card, options: [.missed, .bang], player: "p2")
            .withTurn("p1")
            .withPlayModes(["p1": .manual])
            .build()

        // When
        let result: GamePlayState = sut
        // Then
        XCTAssertEqual(result.message, "P1's turn")
    }
}
