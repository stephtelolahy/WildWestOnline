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
    @Test func dispatchValidAction_shouldEmitNewState() async throws {
        // Given
        let service = SearchService(
            searchResult: .success(["result"]),
            fetchRecentResult: .success(["recent"])
        )
        let sut = await AppStore(
            initialState: .init(),
            reducer: appReducer,
            dependencies: .init(
                search: service.search,
                fetchRecent: service.fetchRecent
            )
        )

        var receivedActions: [ActionProtocol] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            sut.eventPublisher
                .sink { receivedActions.append($0) }
                .store(in: &cancellables)
        }

        // When
        await sut.dispatch(AppAction.fetchRecent)

        // Then
        await #expect(sut.state.searchResult == ["recent"])
        #expect(receivedActions as? [AppAction] == [
            .fetchRecent,
            .setSearchResults(repos: ["recent"])
        ])
    }

    @Test func dispatchInvalidAction_shouldThrowError() async throws {
        // Given
        let service = SearchService(
            searchResult: .success(["result"]),
            fetchRecentResult: .success(["recent"])
        )
        let sut = await AppStore(
            initialState: .init(),
            reducer: appReducer,
            dependencies: .init(
                search: service.search,
                fetchRecent: service.fetchRecent
            )
        )

        var receivedActions: [ActionProtocol] = []
        var receivedErrors: [Error] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            sut.eventPublisher
                .sink { receivedActions.append($0) }
                .store(in: &cancellables)
            sut.errorPublisher
                .sink { receivedErrors.append($0) }
                .store(in: &cancellables)
        }

        // When
        await sut.dispatch(AppAction.search(query: ""))

        // Then
        #expect(receivedErrors as? [SearchError] == [
            .queryStringShouldNotBeEmpty
        ])
        #expect(receivedActions.isEmpty)
    }

    @Test func modifyStateMultipleTimesThroughReducer_shouldEmitOnlyOnce() async throws {
        let sut = await Store<AppState, Void>(
            initialState: .init(),
            reducer: { state, action, _ in
                (0...3).forEach {
                    state.searchResult.append("\($0)")
                }
                return .none
            },
            dependencies: ()
        )
        var receivedStates: [AppState] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            sut.$state
                .sink { receivedStates.append($0) }
                .store(in: &cancellables)
        }

        await sut.dispatch(AppAction.fetchRecent)

        #expect(receivedStates == [
            .init(),
            .init(searchResult: ["0", "1", "2", "3"])
        ])
    }
}

struct AppState: Equatable {
    var searchResult: [String] = []
}

enum AppAction: ActionProtocol, Equatable {
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
    action: ActionProtocol,
    dependencies: AppDependencies
) throws -> Effect {
    switch action {
    case let AppAction.setSearchResults(repos):
        state.searchResult = repos
        return .none

    case let AppAction.search(query):
        guard !query.isEmpty else {
            throw SearchError.queryStringShouldNotBeEmpty
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

    default:
        return .none
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

typealias AppStore = Store<AppState, AppDependencies>

private enum SearchError: Error, Equatable {
    case queryStringShouldNotBeEmpty
}
