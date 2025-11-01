//
//  Features.swift
//
//  Created by Hugues Stéphano TELOLAHY on 12/10/2025.
//
import Redux
import SwiftUI

enum SearchFeature {
    struct State: Equatable {
        var searchResult: [String] = []
    }

    enum Action: Equatable {
        case setSearchResults(repos: [String])
        case search(query: String)
        case fetchRecent
    }

    struct Dependencies {
        var search: (String) async throws -> [String]
        var fetchRecent: () async throws -> [String]
    }

    static func reducer(state: inout State, action: Action, dependencies: Dependencies) -> Effect<Action> {
        switch action {
        case let .setSearchResults(repos):
            state.searchResult = repos
            return .none

        case let .search(query):
            guard !query.isEmpty else {
                return .none
            }
            return .run {
                do {
                    let result = try await dependencies.search(query)
                    return .setSearchResults(repos: result)
                } catch {
                    return .setSearchResults(repos: [])
                }
            }

        case .fetchRecent:
            return .run {
                do {
                    let result = try await dependencies.fetchRecent()
                    return .setSearchResults(repos: result)
                } catch {
                    return .setSearchResults(repos: [])
                }
            }
        }
    }
}

struct SearchService {
    let searchResult: Result<[String], Error>
    let fetchRecentResult: Result<[String], Error>

    func search(query: String) async throws -> [String] {
        switch searchResult {
        case .success(let data):
            return data

        case .failure(let error):
            throw error
        }
    }

    func fetchRecent() async throws -> [String] {
        switch fetchRecentResult {
        case .success(let data):
            return data

        case .failure(let error):
            throw error
        }
    }
}

struct SearchView: View {
    struct ViewState: Equatable {
        let items: [String]
    }

    @ObservedObject var store: Store<ViewState, SearchFeature.Action, Void>
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

extension SearchView.ViewState {
    init?(appState: SearchFeature.State) {
        items = appState.searchResult
    }
}

enum CounterFeature {
    struct State: Equatable { var count = 0 }

    enum Action: Equatable {
        case increment
        case decrement
        case asyncIncrement
        case incremented(Int)
    }

    struct Dependencies {
        var step: Int
    }

    static func reducer(state: inout State, action: Action, dependencies: Dependencies) -> Effect<Action> {
        switch action {
        case .increment:
            state.count += dependencies.step
            return .none

        case .decrement:
            state.count -= dependencies.step
            return .none

        case .asyncIncrement:
            return .run {
                try? await Task.sleep(nanoseconds: 100_000_000)
                return .incremented(1)
            }

        case .incremented(let delta):
            state.count += delta
            return .none
        }
    }
}

enum FlagFeature {
    struct State: Equatable { var isOn = false }

    enum Action: Equatable {
        case toggle
    }

    struct Dependencies {}

    static func reducer(state: inout State, action: Action, dependencies: Dependencies) -> Effect<Action> {
        switch action {
        case .toggle:
            state.isOn.toggle()
            return .none
        }
    }
}

enum GlobalFeature {
    struct State: Equatable {
        var counter = CounterFeature.State()
        var flag = FlagFeature.State()
    }

    enum Action: Equatable {
        case counter(CounterFeature.Action)
        case flag(FlagFeature.Action)
    }

    struct Dependencies {
        var counterDeps: CounterFeature.Dependencies
        var flagDeps: FlagFeature.Dependencies
    }

    static var reducer: Reducer<State, Action, Dependencies> {
        combine(
            pullback(
                CounterFeature.reducer,
                state: { _ in
                    \.counter
                },
                action: { globalAction in
                    if case let .counter(localAction) = globalAction { return localAction }
                    return nil
                },
                embedAction: GlobalFeature.Action.counter,
                dependencies: { $0.counterDeps }
            ),
            pullback(
                FlagFeature.reducer,
                state: { _ in
                    \.flag
                },
                action: { globalAction in
                    if case let .flag(localAction) = globalAction { return localAction }
                    return nil
                },
                embedAction: GlobalFeature.Action.flag,
                dependencies: { $0.flagDeps }
            )
        )
    }
}
