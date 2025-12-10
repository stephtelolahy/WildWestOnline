//
//  QueueModifierClientKey.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import Redux

public extension Dependencies {
    var queueModifierClient: QueueModifierClient {
        get { self[QueueModifierClientKey.self] }
        set { self[QueueModifierClientKey.self] = newValue }
    }
}

private enum QueueModifierClientKey: DependencyKey {
    nonisolated(unsafe) static let defaultValue: QueueModifierClient = .noop
}

private extension QueueModifierClient {
    static var noop: Self {
        .init(
            apply: { _, state in state.queue }
        )
    }
}
