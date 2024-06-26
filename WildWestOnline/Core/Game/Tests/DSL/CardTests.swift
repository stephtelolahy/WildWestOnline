//
//  CardTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Foundation
import GameCore
import XCTest

final class CardTests: XCTestCase {
    func test_Card_shouldBeSerializable() throws {
        // Given
        let JSON = """
        {
            "name": "c1",
            "priority": 1,
            "abilities": [],
            "attributes": {},
            "abilityToPlayCardAs": [],
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
