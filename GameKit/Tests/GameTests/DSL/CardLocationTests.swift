//
//  CardLocationTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Foundation
import Game
import XCTest

final class CardLocationTests: XCTestCase {
    func test_cardLocation_byDefault_shouldBeEmpty() throws {
        let sut = CardLocation()
        XCTAssertEqual(sut.cards, [])
    }

    func test_cardLocation_byDefault_shouldBeVisibleToEveryone() throws {
        let sut = CardLocation()
        XCTAssertFalse(sut.hidden)
    }

    func test_cardLocationVisibility_withHidden_shouldBeHidden() throws {
        let sut = CardLocation(hidden: true)
        XCTAssertTrue(sut.hidden)
    }

    func test_cardLocationCount_withOneCard_shouldBeOne() throws {
        let sut = CardLocation(cards: ["c1"])
        XCTAssertEqual(sut.cards.count, 1)
    }

    func test_cardLocationCards_withTwoCards_shouldBeTwo() throws {
        let sut = CardLocation(cards: ["c1", "c2"])
        XCTAssertEqual(sut.cards, ["c1", "c2"])
    }

    func test_cardLocation_shouldBeSerializable() throws {
        // Given
        let JSON = """
        {
            "hidden": true,
            "cards": [
                "c1",
                "c2"
            ]
        }
        """
        let jsonData = try XCTUnwrap(JSON.data(using: .utf8))

        // When
        let sut = try JSONDecoder().decode(CardLocation.self, from: jsonData)

        // Then
        XCTAssertTrue(sut.hidden)
        XCTAssertEqual(sut.cards, ["c1", "c2"])
    }
}
