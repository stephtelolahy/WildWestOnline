//
//  Mock.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 12/10/2025.
//
import Redux

struct AppState: Equatable {
    var searchResult: [String] = []
}

enum AppAction: Equatable {
    case setSearchResults(repos: [String])
    case search(query: String)
    case fetchRecent
}

struct AppDependencies {
    var search: (String) async throws -> [String]
    var fetchRecent: () async throws -> [String]
}

func appReducer(
    state: inout AppState,
    action: AppAction,
    dependencies: AppDependencies
) -> Effect<AppAction> {
    switch action {
    case let AppAction.setSearchResults(repos):
        state.searchResult = repos
        return .none

    case let AppAction.search(query):
        guard !query.isEmpty else {
            return .none
        }
        return .run {
            do {
                let result = try await dependencies.search(query)
                return AppAction.setSearchResults(repos: result)
            } catch {
                return AppAction.setSearchResults(repos: [])
            }
        }

    case AppAction.fetchRecent:
        return .run {
            do {
                let result = try await dependencies.fetchRecent()
                return AppAction.setSearchResults(repos: result)
            } catch {
                return AppAction.setSearchResults(repos: [])
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
