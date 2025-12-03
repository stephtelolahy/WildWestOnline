//
//  StoreTest.swift
//
//  Created by Hugues Telolahy on 07/04/2023.
//

import Testing
import Redux
import Combine

@MainActor
struct StoreTest {
    @Test func dispatchValidAction_shouldEmitNewState() async throws {
        // Given
        var dependencies = Dependencies()
        dependencies.apiClient = .init(
            search: { _ in ["result"] },
            fetchRecent: { ["recent"] }
        )
        let sut = Store(
            initialState: .init(),
            reducer: SearchFeature.reducer,
            dependencies: dependencies
        )

        var dispatchedActions: [SearchFeature.Action] = []
        var cancellables: Set<AnyCancellable> = []
        sut.dispatchedAction
            .sink { dispatchedActions.append($0) }
            .store(in: &cancellables)

        // When
        await sut.dispatch(.fetchRecent)

        // Then
        #expect(sut.state.searchResult == ["recent"])
        #expect(dispatchedActions == [
            .fetchRecent,
            .setSearchResults(items: ["recent"])
        ])
    }

    @Test func dispatchInvalidAction_shouldNotUpdateState() async throws {
        // Given
        let sut = Store(
            initialState: .init(),
            reducer: SearchFeature.reducer
        )

        var dispatchedActions: [SearchFeature.Action] = []
        var cancellables: Set<AnyCancellable> = []
        sut.dispatchedAction
            .sink { dispatchedActions.append($0) }
            .store(in: &cancellables)

        // When
        await sut.dispatch(.search(query: ""))

        // Then
        #expect(sut.state.searchResult.isEmpty)
    }

    @Test func modifyStateMultipleTimesThroughReducer_shouldEmitOnlyOnce() async throws {
        let sut = Store<SearchFeature.State, SearchFeature.Action>(
            initialState: .init(),
            reducer: { state, _, _ in
                (0...3).forEach {
                    state.searchResult.append("\($0)")
                }
                return .none
            }
        )
        var receivedStates: [SearchFeature.State] = []
        var cancellables: Set<AnyCancellable> = []
        sut.$state
            .sink { receivedStates.append($0) }
            .store(in: &cancellables)

        await sut.dispatch(.fetchRecent)

        #expect(receivedStates == [
            .init(),
            .init(searchResult: ["0", "1", "2", "3"])
        ])
    }
}
