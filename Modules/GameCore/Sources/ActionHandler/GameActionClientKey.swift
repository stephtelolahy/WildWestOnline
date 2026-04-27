//
//  GameActionClientKey.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

import Redux

public extension Dependencies {
    var gameActionClient: GameActionClient {
        get { self[GameActionClientKey.self] }
        set { self[GameActionClientKey.self] = newValue }
    }
}

private enum GameActionClientKey: DependencyKey {
    nonisolated(unsafe) static let defaultValue: GameActionClient = .noop
}

private extension GameActionClient {
    static var noop: Self {
        .init(
            handle: { _, state in state }
        )
    }
}
