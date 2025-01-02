//
//  StoreProjectionTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 02/01/2025.
//

import Redux
import Testing
import Combine

struct StoreProjectionTest {
    @Test func dispatchActionShouldEmitNewState() async throws {
        // Given
        let service = SearchService(
            searchResult: .success(["result"]),
            fetchRecentResult: .success(["recent"])
        )
        let store = await AppStore(
            initialState: .init(),
            reducer: appReducer,
            dependencies: .init(
                search: service.search,
                fetchRecent: service.fetchRecent
            )
        )

        let viewModel: ViewModel = await store.projection(
            deriveState: deriveState,
            embedAction: embedAction
        )

        // When
        await viewModel.dispatch(.didAppear)

        // Then
        await #expect(viewModel.state.content == ["recent"])
    }
}

struct ViewState: Equatable {
    let content: [String]
}

enum ViewAction: Sendable {
    case didAppear
}

typealias ViewModel = Store<ViewState, ViewAction, Void>

func deriveState(state: AppState) -> ViewState? {
    .init(content: state.searchResult)
}

func embedAction(action: ViewAction) -> AppAction {
    switch action {
    case .didAppear:
        .fetchRecent
    }
}
