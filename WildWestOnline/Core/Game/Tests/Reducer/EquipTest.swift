//
//  EquipTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore
import Combine

struct EquipTest {
    @Test func equip_withCardNotInPlay_shouldPutCardInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.equip("c1", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").hand == ["c2"])
        await #expect(sut.state.players.get("p1").inPlay == ["c1"])
        await #expect(sut.state.discard.isEmpty)
    }

    @Test func equip_withCardAlreadyInPlay_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-1"])
                    .withInPlay(["c-2"])
            }
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
        let action = GameAction.equip("c-1", player: "p1")
        await sut.dispatch(action)

        // Then
        #expect(receivedErrors as? [GameError] == [
            .cardAlreadyInPlay("c")
        ])
    }
}
