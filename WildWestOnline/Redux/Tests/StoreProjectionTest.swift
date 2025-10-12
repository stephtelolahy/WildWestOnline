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
    @Test func dispatchViewAction_shouldEmitNewState() async throws {
        // Given
        let service = SearchService(
            searchResult: .success(["result"]),
            fetchRecentResult: .success(["recent"])
        )
        let store = await Store<AppState, AppAction, AppDependencies>(
            initialState: .init(),
            reducer: appReducer,
            dependencies: .init(
                search: service.search,
                fetchRecent: service.fetchRecent
            )
        )

        let sut: Store<SearchView.ViewState, AppAction, Void> = await store.projection(state: SearchView.ViewState.init, action: \.self)

        // When
        await sut.dispatch(AppAction.fetchRecent)

        // Then
        await #expect(sut.state.items == ["recent"])
    }
}

import SwiftUI

private struct SearchView: View {
    struct ViewState: Equatable {
        let items: [String]
    }

    @ObservedObject var store: Store<ViewState, AppAction, Void>
    @State var query: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(store.state.items, id: \.self) { item in
                    Text(item)
                }
            }
            .navigationTitle("Search")
            .searchable(text: $query)
            .onSubmit(of: .search) {
                Task {
                    await store.dispatch(AppAction.search(query: query))
                }
            }
            .task {
                await store.dispatch(AppAction.fetchRecent)
            }
        }
    }
}

extension SearchView.ViewState {
    init?(appState: AppState) {
        items = appState.searchResult
    }
}
