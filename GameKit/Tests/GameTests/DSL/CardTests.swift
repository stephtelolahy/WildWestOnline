//
//  CardTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Foundation
import Game
import XCTest

final class CardTests: XCTestCase {
    func test_Card_initially_shouldHaveName() throws {
        let sut = Card("c1")
        XCTAssertEqual(sut.name, "c1")
    }

    func test_Card_shouldBeSerializable() throws {
        // Given
        let JSON = """
        {
            "name": "c1",
            "priority": 1,
            "attributes": {},
            "rules": []
        }
        """
        let jsonData = try XCTUnwrap(JSON.data(using: .utf8))

        // When
        let sut = try JSONDecoder().decode(Card.self, from: jsonData)

        // Then
        XCTAssertEqual(sut.name, "c1")
    }
}
