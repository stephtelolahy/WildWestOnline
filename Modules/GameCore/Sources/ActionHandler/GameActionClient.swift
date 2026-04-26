//
//  GameActionClient.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

public struct GameActionClient {
    public var handle: (GameFeature.Action, GameFeature.State) throws(GameFeature.Error) -> GameFeature.State

    public init(handle: @escaping (GameFeature.Action, GameFeature.State) throws(GameFeature.Error) -> GameFeature.State) {
        self.handle = handle
    }
}
