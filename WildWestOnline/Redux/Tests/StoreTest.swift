//
//  StoreTest.swift
//
//  Created by Hugues Telolahy on 07/04/2023.
//

import Redux
import Testing
import Combine

@MainActor
struct StoreTest {
    @Test func dispatchValidAction_shouldEmitNewState() async throws {
        // Given
        let service = SearchService(
            searchResult: .success(["result"]),
            fetchRecentResult: .success(["recent"])
        )
        let sut = Store<SearchFeature.State, SearchFeature.Action, SearchFeature.Dependencies>(
            initialState: .init(),
            reducer: SearchFeature.reducer,
            dependencies: .init(
                search: service.search,
                fetchRecent: service.fetchRecent
            )
        )

        var dispatchedActions: [SearchFeature.Action] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            sut.dispatchedAction
                .sink { dispatchedActions.append($0) }
                .store(in: &cancellables)
        }

        // When
        await sut.dispatch(.fetchRecent)

        // Then
        #expect(sut.state.searchResult == ["recent"])
        #expect(dispatchedActions == [
            .fetchRecent,
            .setSearchResults(repos: ["recent"])
        ])
    }

    @Test func dispatchInvalidAction_shouldNotUpdateState() async throws {
        // Given
        let service = SearchService(
            searchResult: .success(["result"]),
            fetchRecentResult: .success(["recent"])
        )
        let sut = Store<SearchFeature.State, SearchFeature.Action, SearchFeature.Dependencies>(
            initialState: .init(),
            reducer: SearchFeature.reducer,
            dependencies: .init(
                search: service.search,
                fetchRecent: service.fetchRecent
            )
        )

        var dispatchedActions: [SearchFeature.Action] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            sut.dispatchedAction
                .sink { dispatchedActions.append($0) }
                .store(in: &cancellables)
        }

        // When
        await sut.dispatch(.search(query: ""))

        // Then
        #expect(sut.state.searchResult.isEmpty)
    }

    @Test func modifyStateMultipleTimesThroughReducer_shouldEmitOnlyOnce() async throws {
        let sut = Store<SearchFeature.State, SearchFeature.Action, SearchFeature.Dependencies>(
            initialState: .init(),
            reducer: { state, _, _ in
                (0...3).forEach {
                    state.searchResult.append("\($0)")
                }
                return .none
            },
            dependencies: .init(search: { _ in [] }, fetchRecent: { [] })
        )
        var receivedStates: [SearchFeature.State] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            sut.$state
                .sink { receivedStates.append($0) }
                .store(in: &cancellables)
        }

        await sut.dispatch(.fetchRecent)

        #expect(receivedStates == [
            .init(),
            .init(searchResult: ["0", "1", "2", "3"])
        ])
    }
}
