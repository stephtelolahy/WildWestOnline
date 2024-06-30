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
    func test_buildPlayer_byDefault_shouldHaveDefaultIdentifier() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertNotEqual(sut.id, "")
    }

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

    func test_buildPlayer_byDefault_shouldHaveEmptyHand() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertEqual(sut.hand, [])
    }

    func test_buildPlayer_byDefault_shouldHaveEmptyInPlay() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertEqual(sut.inPlay, [])
    }

    func test_buildPlayer_withIdentifier_shouldHaveIdentifier() throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withId("p1")
            .build()

        // Then
        XCTAssertEqual(sut.id, "p1")
    }

    func test_buildPlayer_withHand_shouldHaveHandCards() throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withHand(["c1", "c2"])
            .build()

        // Then
        XCTAssertEqual(sut.hand, ["c1", "c2"])
    }

    func test_buildPlayer_withInPlay_shouldHaveInPlayCards() throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withInPlay(["c1", "c2"])
            .build()

        // Then
        XCTAssertEqual(sut.inPlay, ["c1", "c2"])
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
