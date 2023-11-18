//
//  CardStackTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//
// swiftlint:disable no_magic_numbers

import Foundation
import Game
import XCTest

final class CardStackTests: XCTestCase {
    func test_cardStack_byDefault_shouldBeEmpty() throws {
        let sut = CardStack()
        XCTAssertEqual(sut.cards, [])
    }

    func test_cardStackTop_withCards_shouldBeFirstCard() throws {
        let sut = CardStack(cards: ["c1", "c2"])
        XCTAssertEqual(sut.top, "c1")
    }

    func test_cardStack_shouldBeSerializable() throws {
        // Given
        let JSON = """
        {
            "cards": [
                "c1",
                "c2"
            ]
        }
        """
        let jsonData = try XCTUnwrap(JSON.data(using: .utf8))

        // When
        let sut = try JSONDecoder().decode(CardStack.self, from: jsonData)

        // Then
        // Then
        XCTAssertEqual(sut.count, 2)
        XCTAssertEqual(sut.top, "c1")
    }
}
