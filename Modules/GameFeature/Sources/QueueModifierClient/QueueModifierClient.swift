//
//  QueueModifierClient.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

public struct QueueModifierClient {
    public var apply: (GameFeature.Action, GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action]

    public init(apply: @escaping (GameFeature.Action, GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action]) {
        self.apply = apply
    }
}

public extension QueueModifierClient {
    static var empty: Self {
        .init(apply: { _, state in state.queue })
    }
}
