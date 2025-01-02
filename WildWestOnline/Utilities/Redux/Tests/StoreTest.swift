//
//  StoreTest.swift
//
//
//  Created by Hugues Telolahy on 07/04/2023.
//

import Redux
import Testing

struct StoreTest {

    struct AppState: Equatable {
        var searchResult: [String] = []
    }

    enum AppAction {
        case setSearchResults(repos: [String])
        case search(query: String)
        case fetchRecent
    }

    struct AppDependencies : Sendable {
        var search: @Sendable (String) async throws -> [String]
        var fetchRecent:  @Sendable () async throws -> [String]
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
        func search(query: String) async throws -> [String] {
            ["result"]
        }

        func fetchRecent() async throws -> [String] {
            ["recent"]
        }
    }

    typealias AppStore = Store<AppState, AppAction, AppDependencies>

    @Test func createStore() async throws {
        // Given
        let service = SearchService()
        let store: AppStore = await .init(
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
