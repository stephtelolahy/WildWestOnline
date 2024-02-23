//
//  DistanceTests.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//
// swiftlint:disable no_magic_numbers

@testable import GameCore
import XCTest

final class DistanceTests: XCTestCase {
    func test_distance_withoutEquipement_shouldBeTheLowestValue() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPlayer("p3")
            .withPlayer("p4")
            .withPlayer("p5")
            .build()

        // When
        // Then
        XCTAssertEqual(state.playersAt(1, from: "p1"), ["p2", "p5"])
        XCTAssertEqual(state.playersAt(2, from: "p1"), ["p2", "p3", "p4", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p2"), ["p1", "p3"])
        XCTAssertEqual(state.playersAt(2, from: "p2"), ["p1", "p3", "p4", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p3"), ["p2", "p4"])
        XCTAssertEqual(state.playersAt(2, from: "p3"), ["p1", "p2", "p4", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p4"), ["p3", "p5"])
        XCTAssertEqual(state.playersAt(2, from: "p4"), ["p1", "p2", "p3", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p5"), ["p1", "p4"])
        XCTAssertEqual(state.playersAt(2, from: "p5"), ["p1", "p2", "p3", "p4"])
    }

    func test_distance_withScope_shouldDecrementDistanceToOthers() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withAttributes([.scope: 1])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withPlayer("p4")
            .withPlayer("p5")
            .build()

        // When
        // Then
        XCTAssertEqual(state.playersAt(1, from: "p1"), ["p2", "p3", "p4", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p2"), ["p1", "p3"])
        XCTAssertEqual(state.playersAt(2, from: "p2"), ["p1", "p3", "p4", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p3"), ["p2", "p4"])
        XCTAssertEqual(state.playersAt(2, from: "p3"), ["p1", "p2", "p4", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p4"), ["p3", "p5"])
        XCTAssertEqual(state.playersAt(2, from: "p4"), ["p1", "p2", "p3", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p5"), ["p1", "p4"])
        XCTAssertEqual(state.playersAt(2, from: "p5"), ["p1", "p2", "p3", "p4"])
    }

    func test_distance_withMustang_shouldIncrementDistanceFromOthers() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withAttributes([.mustang: 1])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withPlayer("p4")
            .withPlayer("p5")
            .build()

        // When
        // Then
        XCTAssertEqual(state.playersAt(1, from: "p2"), ["p3"])
        XCTAssertEqual(state.playersAt(2, from: "p2"), ["p1", "p3", "p4", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p3"), ["p2", "p4"])
        XCTAssertEqual(state.playersAt(2, from: "p3"), ["p2", "p4", "p5"])
        XCTAssertEqual(state.playersAt(3, from: "p3"), ["p1", "p2", "p4", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p4"), ["p3", "p5"])
        XCTAssertEqual(state.playersAt(2, from: "p4"), ["p2", "p3", "p5"])
        XCTAssertEqual(state.playersAt(3, from: "p4"), ["p1", "p2", "p3", "p5"])

        XCTAssertEqual(state.playersAt(1, from: "p5"), ["p4"])
        XCTAssertEqual(state.playersAt(2, from: "p5"), ["p1", "p2", "p3", "p4"])
    }
}
