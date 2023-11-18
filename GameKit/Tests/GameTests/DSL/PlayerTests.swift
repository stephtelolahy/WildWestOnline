//
//  PlayerTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//
import Game
import XCTest
import Nimble
import Foundation

final class PlayerTests: XCTestCase {

    func test_buildPlayer_byDefault_shouldHaveDefaultIdentifier() throws {
        let sut = Player.makeBuilder()
            .build()
        expect(sut.id).toNot(beEmpty())
    }

    func test_buildPlayer_byDefault_shouldHaveEmptyName() throws {
        let sut = Player.makeBuilder()
            .build()
        expect(sut.name).to(beEmpty())
    }

    func test_buildPlayer_byDefault_shouldNotHaveAttributes() throws {
        let sut = Player.makeBuilder()
            .build()
        expect(sut.attributes) == [:]
    }

    func test_buildPlayer_byDefault_shouldHaveEmptyHand() throws {
        let sut = Player.makeBuilder()
            .build()
        expect(sut.hand.cards).to(beEmpty())
    }

    func test_buildPlayer_byDefault_shouldHaveHealthZero() throws {
        let sut = Player.makeBuilder()
            .build()
        expect(sut.health) == 0
    }

    func test_buildPlayer_byDefault_shouldHaveEmptyInPlay() throws {
        let sut = Player.makeBuilder()
            .build()
        expect(sut.inPlay.cards).to(beEmpty())
    }

    func test_buildPlayer_byDefault_should() throws {
        let sut = Player.makeBuilder()
            .build()
    }

    func test_buildPlayer_withIdentifier_shouldHaveIdentifier() throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withId("p1")
            .build()

        // Then
        expect(sut.id) == "p1"
    }

    func test_buildPlayer_withHand_shouldHaveHandCards() throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withHand(["c1", "c2"])
            .build()

        // Then
        expect(sut.hand.cards) == ["c1", "c2"]
    }

    func test_buildPlayer_withInPlay_shouldHaveInPlayCards() throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withInPlay(["c1", "c2"])
            .build()

        // Then
        expect(sut.inPlay.cards) == ["c1", "c2"]
    }

    func test_buildPlayer_withAttributes_shouldHaveAttributes() throws {
        // Given
        // When
        let sut = Player.makeBuilder()
            .withAttributes([.mustang: 1])
            .build()

        // Then
        expect(sut.attributes[.mustang]) == 1
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
        expect(sut.id) == "p1"
        expect(sut.name) == "n1"
        expect(sut.attributes[.maxHealth]) == 4
        expect(sut.health) == 2
        expect(sut.attributes[.handLimit]) == 2
        expect(sut.attributes[.weapon]) == 3
        expect(sut.attributes[.mustang]) == 0
        expect(sut.attributes[.scope]) == 1
        expect(sut.attributes[.startTurnCards]) == 2

    }
}
