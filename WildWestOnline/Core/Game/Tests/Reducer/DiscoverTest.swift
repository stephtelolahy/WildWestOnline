//
//  DiscoverTest.swift
//  BangTest
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore
import Combine

struct DiscoverTest {
    @Test func discover_shouldAddCardToDiscovered() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.discover(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.discovered == ["c1"])
        await #expect(sut.state.deck == ["c1", "c2", "c3"])
    }

    @Test func discover_withAlreadyDiscoveredCard_shouldAddCardNextToDiscovered() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c1", "c2", "c3"])
            .withDiscovered(["c1"])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.discover(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.discovered == ["c1", "c2"])
        await #expect(sut.state.deck == ["c1", "c2", "c3"])
    }

    @Test func discover_emptyDeck_withEnoughCards_shouldResetDeck() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck([])
            .withDiscard(["c1", "c2"])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.discover(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.discovered == ["c2"])
        await #expect(sut.state.deck == ["c2"])
        await #expect(sut.state.discard == ["c1"])
    }

    @Test func discover_emptyDeck_withoutEnoughCards_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .build()
        let sut = await createGameStore(initialState: state)

        var receivedErrors: [Error] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            sut.errorPublisher
                .sink { receivedErrors.append($0) }
                .store(in: &cancellables)
        }

        // When
        let action = GameAction.discover(player: "p1")
        await sut.dispatch(action)

        // Then
        #expect(receivedErrors as? [GameError] == [
            .insufficientDeck
        ])
    }

    @Test func discover_nonEmptyDeck_withoutEnoughCards_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDiscovered(["c1"])
            .withDeck(["c1"])
            .build()
        let sut = await createGameStore(initialState: state)

        var receivedErrors: [Error] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            sut.errorPublisher
                .sink { receivedErrors.append($0) }
                .store(in: &cancellables)
        }

        // When
        let action = GameAction.discover(player: "p1")
        await sut.dispatch(action)

        // Then
        #expect(receivedErrors as? [GameError] == [
            .insufficientDeck
        ])
    }
}
