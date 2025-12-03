//
//  APIClient.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import Redux

struct APIClient: Sendable {
    var search: @Sendable (String) async throws -> [String]
    var fetchRecent: @Sendable () async throws -> [String]
}

extension Dependencies {
    var apiClient: APIClient {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}

private enum APIClientKey: DependencyKey {
    static let defaultValue: APIClient = .noop
}

private extension APIClient {
    static let noop: Self = .init(
        search: { @Sendable _ in [] },
        fetchRecent: { @Sendable in [] }
    )
}
