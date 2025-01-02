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

        let connector = SearchView.Connector()
        let viewModel: SearchView.ViewModel = await store.projection(
            deriveState: connector.deriveState,
            embedAction: connector.embedAction
        )

        // When
        await viewModel.dispatch(.didAppear)

        // Then
        await #expect(viewModel.state.items == ["recent"])
    }
}

import SwiftUI

struct SearchView: View {
    struct State: Equatable {
        let items: [String]
    }

    enum Action: Sendable {
        case didAppear
        case searchTextChanged(String)
    }

    typealias ViewModel = Store<State, Action, Void>
    @ObservedObject var store: ViewModel
    @SwiftUI.State var query: String = ""

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
                    await store.dispatch(.searchTextChanged(query))
                }
            }
            .task {
                await store.dispatch(.didAppear)
            }
        }
    }
}

extension SearchView {
    struct Connector {
        func deriveState(state: AppState) -> State? {
            .init(items: state.searchResult)
        }

        func embedAction(action: Action) -> AppAction {
            switch action {
            case .didAppear:
                .fetchRecent
            case .searchTextChanged(let text):
                .search(query: text)
            }
        }
    }
}

