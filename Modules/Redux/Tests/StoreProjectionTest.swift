//
//  StoreProjectionTest.swift
//
//  Created by Hugues Stéphano TELOLAHY on 02/01/2025.
//

import Testing
import Redux
import SwiftUI

struct StoreProjectionTest {
    @Test func dispatchViewAction_shouldEmitNewState() async throws {
        // Given
        let store = await Store<SearchFeature.State, SearchFeature.Action>(
            initialState: .init(),
            reducer: SearchFeature.reducer,
            withDependencies: {
                $0.apiClient.search = { _ in [] }
                $0.apiClient.fetchRecent = { ["recent"] }
            }
        )

        let sut = await store.projection(state: SearchView.ViewState.init, action: \.self)

        // When
        await sut.dispatch(.fetchRecent)

        // Then
        await #expect(sut.state.items == ["recent"])
    }
}

private struct SearchView: View {
    struct ViewState: Equatable {
        let items: [String]
    }

    @ObservedObject var store: Store<ViewState, SearchFeature.Action>
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
                    await store.dispatch(.search(query: query))
                }
            }
            .task {
                await store.dispatch(.fetchRecent)
            }
        }
    }
}

private extension SearchView.ViewState {
    init?(appState: SearchFeature.State) {
        items = appState.searchResult
    }
}
