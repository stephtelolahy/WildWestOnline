//
//  DistanceTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 05/11/2024.
//

@testable import GameFeature
import Testing

struct DistanceTest {
    @Test func distance_withoutEquipement_shouldBeTheLowestValue() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPlayer("p3")
            .withPlayer("p4")
            .withPlayer("p5")
            .build()

        // When
        // Then
        #expect(state.distance(from: "p1", to: "p2") == 1)
        #expect(state.distance(from: "p1", to: "p5") == 1)
        #expect(state.distance(from: "p1", to: "p3") == 2)
        #expect(state.distance(from: "p1", to: "p4") == 2)

        #expect(state.distance(from: "p2", to: "p1") == 1)
        #expect(state.distance(from: "p2", to: "p3") == 1)
        #expect(state.distance(from: "p2", to: "p4") == 2)
        #expect(state.distance(from: "p2", to: "p5") == 2)

        #expect(state.distance(from: "p3", to: "p2") == 1)
        #expect(state.distance(from: "p3", to: "p4") == 1)
        #expect(state.distance(from: "p3", to: "p1") == 2)
        #expect(state.distance(from: "p3", to: "p5") == 2)

        #expect(state.distance(from: "p4", to: "p3") == 1)
        #expect(state.distance(from: "p4", to: "p5") == 1)
        #expect(state.distance(from: "p4", to: "p1") == 2)
        #expect(state.distance(from: "p4", to: "p2") == 2)

        #expect(state.distance(from: "p5", to: "p1") == 1)
        #expect(state.distance(from: "p5", to: "p4") == 1)
        #expect(state.distance(from: "p5", to: "p2") == 2)
        #expect(state.distance(from: "p5", to: "p3") == 2)
    }

    @Test func distance_withScope_shouldDecrementDistanceToOthers() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
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
        #expect(state.distance(from: "p1", to: "p2") == 0)
        #expect(state.distance(from: "p1", to: "p5") == 0)
        #expect(state.distance(from: "p1", to: "p3") == 1)
        #expect(state.distance(from: "p1", to: "p4") == 1)
    }

    @Test func distance_withRemoteness_shouldIncrementDistanceFromOthers() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
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
        #expect(state.distance(from: "p2", to: "p1") == 2)
        #expect(state.distance(from: "p5", to: "p1") == 2)
        #expect(state.distance(from: "p3", to: "p1") == 3)
        #expect(state.distance(from: "p4", to: "p1") == 3)
    }
}
