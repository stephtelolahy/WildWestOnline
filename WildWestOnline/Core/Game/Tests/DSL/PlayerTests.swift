//
//  PlayerTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Foundation
import GameCore
import XCTest

final class PlayerTests: XCTestCase {
    func test_buildPlayer_byDefault_shouldHaveEmptyFigure() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertEqual(sut.figure, "")
    }

    func test_buildPlayer_byDefault_shouldNotHaveAttributes() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertEqual(sut.attributes, [:])
    }

    func test_buildPlayer_withHand_shouldHaveHandCards() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // Then
        XCTAssertEqual(sut.field.hand["p1"], ["c1", "c2"])
    }

    func test_buildPlayer_withInPlay_shouldHaveInPlayCards() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withInPlay(["c1", "c2"])
            }
            .build()

        // Then
        XCTAssertEqual(sut.field.inPlay["p1"], ["c1", "c2"])
    }

    func test_buildPlayer_withAttributes_shouldHaveAttributes() throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withAttributes([.remoteness: 1])
            .build()

        // Then
        XCTAssertEqual(sut.attributes[.remoteness], 1)
    }
}
