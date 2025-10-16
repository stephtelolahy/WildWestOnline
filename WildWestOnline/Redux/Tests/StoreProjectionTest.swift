//
//  StoreProjectionTest.swift
//
//  Created by Hugues Stéphano TELOLAHY on 02/01/2025.
//

import Redux
import Testing

struct StoreProjectionTest {
    @Test func dispatchViewAction_shouldEmitNewState() async throws {
        // Given
        let service = SearchService(
            searchResult: .success(["result"]),
            fetchRecentResult: .success(["recent"])
        )
        let store = await Store<SearchFeature.State, SearchFeature.Action, SearchFeature.Dependencies>(
            initialState: .init(),
            reducer: SearchFeature.reducer,
            dependencies: .init(
                search: service.search,
                fetchRecent: service.fetchRecent
            )
        )

        let sut = await store.projection(state: SearchView.ViewState.init, action: \.self)

        // When
        await sut.dispatch(SearchFeature.Action.fetchRecent)

        // Then
        await #expect(sut.state.items == ["recent"])
    }
}
