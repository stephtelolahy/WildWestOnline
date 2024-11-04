//
//  DistanceTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 05/11/2024.
//

import Testing
import Bang

struct DistanceTest {
    @Test func test_distance_withoutEquipement_shouldBeTheLowestValue() async throws {
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
        #expect(state.playersAt(1, from: "p1") == ["p2", "p5"])
        #expect(state.playersAt(2, from: "p1") == ["p2", "p3", "p4", "p5"])

        #expect(state.playersAt(1, from: "p2") == ["p1", "p3"])
        #expect(state.playersAt(2, from: "p2") == ["p1", "p3", "p4", "p5"])

        #expect(state.playersAt(1, from: "p3") == ["p2", "p4"])
        #expect(state.playersAt(2, from: "p3") == ["p1", "p2", "p4", "p5"])

        #expect(state.playersAt(1, from: "p4") == ["p3", "p5"])
        #expect(state.playersAt(2, from: "p4") == ["p1", "p2", "p3", "p5"])

        #expect(state.playersAt(1, from: "p5") == ["p1", "p4"])
        #expect(state.playersAt(2, from: "p5") == ["p1", "p2", "p3", "p4"])
    }

    @Test func test_distance_withScope_shouldDecrementDistanceToOthers() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withMagnifying(1)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withPlayer("p4")
            .withPlayer("p5")
            .build()

        // When
        // Then
        #expect(state.playersAt(1, from: "p1") == ["p2", "p3", "p4", "p5"])

        #expect(state.playersAt(1, from: "p2") == ["p1", "p3"])
        #expect(state.playersAt(2, from: "p2") == ["p1", "p3", "p4", "p5"])

        #expect(state.playersAt(1, from: "p3") == ["p2", "p4"])
        #expect(state.playersAt(2, from: "p3") == ["p1", "p2", "p4", "p5"])

        #expect(state.playersAt(1, from: "p4") == ["p3", "p5"])
        #expect(state.playersAt(2, from: "p4") == ["p1", "p2", "p3", "p5"])

        #expect(state.playersAt(1, from: "p5") == ["p1", "p4"])
        #expect(state.playersAt(2, from: "p5") == ["p1", "p2", "p3", "p4"])
    }

    @Test func test_distance_withRemoteness_shouldIncrementDistanceFromOthers() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withRemoteness(1)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withPlayer("p4")
            .withPlayer("p5")
            .build()

        // When
        // Then
        #expect(state.playersAt(1, from: "p2") == ["p3"])
        #expect(state.playersAt(2, from: "p2") == ["p1", "p3", "p4", "p5"])

        #expect(state.playersAt(1, from: "p3") == ["p2", "p4"])
        #expect(state.playersAt(2, from: "p3") == ["p2", "p4", "p5"])
        #expect(state.playersAt(3, from: "p3") == ["p1", "p2", "p4", "p5"])

        #expect(state.playersAt(1, from: "p4") == ["p3", "p5"])
        #expect(state.playersAt(2, from: "p4") == ["p2", "p3", "p5"])
        #expect(state.playersAt(3, from: "p4") == ["p1", "p2", "p3", "p5"])

        #expect(state.playersAt(1, from: "p5") == ["p4"])
        #expect(state.playersAt(2, from: "p5") == ["p1", "p2", "p3", "p4"])
    }
}

private extension GameState {
    func playersAt(_ range: Int, from player: String) -> [String] {
        playOrder
            .filter { $0 != player }
            .filter { distance(from: player, to: $0) <= range }
    }
}
