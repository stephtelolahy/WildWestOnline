//
//  SearchFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import Redux

enum SearchFeature {
    struct State: Equatable {
        var searchResult: [String] = []
    }

    enum Action: Equatable {
        case setSearchResults(items: [String])
        case search(query: String)
        case fetchRecent
    }

    static func reducer(state: inout State, action: Action, dependencies: Dependencies) -> Effect<Action> {
        switch action {
        case let .setSearchResults(items):
            state.searchResult = items
            return .none

        case let .search(query):
            guard !query.isEmpty else {
                return .none
            }
            return .run {
                do {
                    let result = try await dependencies.apiClient.search(query)
                    return .setSearchResults(items: result)
                } catch {
                    return .setSearchResults(items: [])
                }
            }

        case .fetchRecent:
            return .run {
                do {
                    let result = try await dependencies.apiClient.fetchRecent()
                    return .setSearchResults(items: result)
                } catch {
                    return .setSearchResults(items: [])
                }
            }
        }
    }
}
