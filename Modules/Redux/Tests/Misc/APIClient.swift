//
//  APIClient.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import Redux

struct APIClient {
    var search: (String) async throws -> [String]
    var fetchRecent: () async throws -> [String]
}

extension Dependencies {
    var apiClient: APIClient {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}

private enum APIClientKey: DependencyKey {
    nonisolated(unsafe) static let defaultValue: APIClient = .noop
}

private extension APIClient {
    static var noop: Self {
        .init(
            search: { _ in [] },
            fetchRecent: { [] }
        )
    }
}
