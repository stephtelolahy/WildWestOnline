//
//  PlayerTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//
import Game
import XCTest
import Foundation

final class PlayerTests: XCTestCase {

    func test_buildPlayer_byDefault_shouldHaveDefaultIdentifier() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertNotEqual(sut.id, "")
    }

    func test_buildPlayer_byDefault_shouldHaveEmptyName() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertEqual(sut.name, "")
    }

    func test_buildPlayer_byDefault_shouldNotHaveAttributes() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertEqual(sut.attributes, [:])
    }

    func test_buildPlayer_byDefault_shouldHaveEmptyHand() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertEqual(sut.hand.cards, [])
    }

    func test_buildPlayer_byDefault_shouldHaveHealthZero() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertEqual(sut.health, 0)
    }

    func test_buildPlayer_byDefault_shouldHaveEmptyInPlay() throws {
        let sut = Player.makeBuilder()
            .build()
        XCTAssertEqual(sut.inPlay.cards, [])
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
        XCTAssertEqual(sut.hand.cards, ["c1", "c2"])
    }

    func test_buildPlayer_withInPlay_shouldHaveInPlayCards() throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withInPlay(["c1", "c2"])
            .build()

        // Then
        XCTAssertEqual(sut.inPlay.cards, ["c1", "c2"])
    }

    func test_buildPlayer_withAttributes_shouldHaveAttributes() throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withAttributes([.mustang: 1])
            .build()

        // Then
        XCTAssertEqual(sut.attributes[.mustang], 1)
    }

    func test_player_shouldBeSerializable() throws {
        // Given
        let JSON = """
        {
            "id": "p1",
            "name": "n1",
            "health": 2,
            "attributes": {
                "maxHealth": 4,
                "mustang": 0,
                "scope": 1,
                "weapon": 3,
                "handLimit": 2,
                "startTurnCards": 2,
                "endTurn": 0
            },
            "hand": {
                "hidden": true,
                "cards": []
            },
            "inPlay": {
                "hidden": false,
                "cards": []
            }
        }
        """
        let jsonData = try XCTUnwrap(JSON.data(using: .utf8))

        // When
        let sut = try JSONDecoder().decode(Player.self, from: jsonData)

        // Then
        XCTAssertEqual(sut.id, "p1")
        XCTAssertEqual(sut.name, "n1")
        XCTAssertEqual(sut.attributes[.maxHealth], 4)
        XCTAssertEqual(sut.health, 2)
        XCTAssertEqual(sut.attributes[.handLimit], 2)
        XCTAssertEqual(sut.attributes[.weapon], 3)
        XCTAssertEqual(sut.attributes[.mustang], 0)
        XCTAssertEqual(sut.attributes[.scope], 1)
        XCTAssertEqual(sut.attributes[.startTurnCards], 2)

    }
}
