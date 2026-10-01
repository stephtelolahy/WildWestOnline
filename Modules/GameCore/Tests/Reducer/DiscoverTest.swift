//
//  DiscoverTest.swift
//  BangTest
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore

struct DiscoverTest {
    @Test func discover_shouldAddCardToDiscovered() async throws {
        let state = GameFeature.State.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .build()

        let result = try await dispatch(.discover(), state: state)

        #expect(result.discovered == ["c1"])
        #expect(result.deck == ["c1", "c2", "c3"])
    }

    @Test func discover_withAlreadyDiscoveredCard_shouldAddCardNextToDiscovered() async throws {
        let state = GameFeature.State.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .withDiscovered(["c1"])
            .build()

        let result = try await dispatch(.discover(), state: state)

        #expect(result.discovered == ["c1", "c2"])
        #expect(result.deck == ["c1", "c2", "c3"])
    }

    @Test func discover_emptyDeck_shouldResetDeck() async throws {
        let state = GameFeature.State.makeBuilder()
            .withDeck([])
            .withDiscard(["c1", "c2"])
            .build()

        let result = try await dispatch(.discover(), state: state)

        #expect(result.discovered == ["c2"])
        #expect(result.deck == ["c2"])
        #expect(result.discard == ["c1"])
    }

    @Test func discover_emptyDeck_withoutEnoughCards_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilder()
            .build()

        await #expect(throws: GameFeature.Error.insufficientDeck) {
            try await dispatch(.discover(), state: state)
        }
    }

    @Test func discover_nonEmptyDeck_withoutEnoughCards_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilder()
            .withDiscovered(["c1"])
            .withDeck(["c1"])
            .build()

        await #expect(throws: GameFeature.Error.insufficientDeck) {
            try await dispatch(.discover(), state: state)
        }
    }
}
