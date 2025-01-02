//
//  StoreTest.swift
//
//
//  Created by Hugues Telolahy on 07/04/2023.
//

import Redux
import Testing

struct StoreTest {
    @Test func dispatchActionShouldEmitNewState() async throws {
        // Given
        var service = SearchService()
        service.fetchRecentResult = .success(["recent"])
        let store = await AppStore(
            initialState: .init(),
            reducer: appReducer,
            dependencies: .init(
                search: service.search,
                fetchRecent: service.fetchRecent
            )
        )

        // When
        await store.dispatch(.fetchRecent)

        // Then
        await #expect(store.state.searchResult == ["recent"])
    }
}

struct AppState: Equatable {
    var searchResult: [String] = []
}

enum AppAction {
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
    case let .setSearchResults(repos):
        state.searchResult = repos
        return .none

    case let .search(query):
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

struct SearchService {
    var searchResult: Result<[String], Error> = .success([])
    var fetchRecentResult: Result<[String], Error> = .success([])

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

typealias AppStore = Store<AppState, AppAction, AppDependencies>
