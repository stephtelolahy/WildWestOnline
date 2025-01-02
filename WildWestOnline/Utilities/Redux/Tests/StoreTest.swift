//
//  StoreTest.swift
//
//
//  Created by Hugues Telolahy on 07/04/2023.
//

import Redux
import Testing
import Combine

struct StoreTest {
    @Test func dispatchValidAction_ShouldEmitNewState() async throws {
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

        var receivedActions: [AppAction] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            store.eventPublisher
                .sink { receivedActions.append($0) }
                .store(in: &cancellables)
        }

        // When
        await store.dispatch(.fetchRecent)

        // Then
        await #expect(store.state.searchResult == ["recent"])
        #expect(receivedActions == [
            .fetchRecent,
            .setSearchResults(repos: ["recent"])
        ])
    }

    @Test func dispatchInvalidAction_ShouldThrowError() async throws {
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

        var receivedActions: [AppAction] = []
        var receivedErrors: [Error] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            store.eventPublisher
                .sink { receivedActions.append($0) }
                .store(in: &cancellables)
            store.errorPublisher
                .sink { receivedErrors.append($0) }
                .store(in: &cancellables)
        }

        // When
        await store.dispatch(.search(query: ""))

        // Then
        await #expect(store.state.searchResult == [""])
        #expect(receivedErrors as? [SearchError] == [
            .queryStringShouldNotBeEmpty
        ])
        #expect(receivedActions == [
            .search(query: "")
        ])
    }
}

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
) throws -> Effect<AppAction> {
    switch action {
    case let .setSearchResults(repos):
        state.searchResult = repos
        return .none

    case let .search(query):
        guard !query.isEmpty else {
            throw SearchError.queryStringShouldNotBeEmpty
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

typealias AppStore = Store<AppState, AppAction, AppDependencies>

enum SearchError: Error, Equatable {
    case queryStringShouldNotBeEmpty
}
