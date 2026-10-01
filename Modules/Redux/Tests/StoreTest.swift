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
        let sut = Store(
            initialState: .init(),
            reducer: SearchFeature.reducer,
            withDependencies: {
                $0.apiClient.search = { _ in ["result"] }
                $0.apiClient.fetchRecent = { ["recent"] }
            }
        )

        let received = await sut.receive(.fetchRecent)

        #expect(sut.state.searchResult == ["recent"])
        #expect(received == [.setSearchResults(items: ["recent"])])
    }

    @Test func dispatchInvalidAction_shouldNotUpdateState() async throws {
        let sut = Store(
            initialState: .init(),
            reducer: SearchFeature.reducer
        )

        await sut.dispatch(.search(query: ""))

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
