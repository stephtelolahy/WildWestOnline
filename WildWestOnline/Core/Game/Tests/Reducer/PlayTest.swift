//
//  PlayTest.swift
//  BangTests
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Testing
import GameCore
import Combine

struct PlayTest {
    @Test func play_shouldNotDiscard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withCards(["c1": Card(name: "c1", onPlay: [.init(action: .drawDeck)])])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.play("c1", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").hand == ["c1"])
        await #expect(sut.state.discard.isEmpty)
    }

    @Test func play_firstTime_shouldSetPlayedThisTurn() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withCards(["c1": Card(name: "c1", onPlay: [.init(action: .drawDeck)])])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.play("c1", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.playedThisTurn["c1"] == 1)
    }

    @Test func play_secondTime_shouldIncrementPlayedThisTurn() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withCards(["c1": Card(name: "c1", onPlay: [.init(action: .drawDeck)])])
            .withPlayedThisTurn(["c1": 1])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.play("c1", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.playedThisTurn["c1"] == 2)
    }

    @Test func play_shouldQueueEffectsOfMatchingCardName() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-2❤️"])
            }
            .withCards(["c": Card(name: "c", onPlay: [.init(action: .drawDeck)])])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.play("c-2❤️", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.queue.count == 1)
    }

    @Test func play_withoutEffects_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .withCards(["c1": Card(name: "c1")])
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
        let action = GameAction.play("c1", player: "p1")
        await sut.dispatch(action)

        // Assert
        #expect(receivedErrors as? [GameError] == [
            .cardNotPlayable("c1")
        ])
    }
}
