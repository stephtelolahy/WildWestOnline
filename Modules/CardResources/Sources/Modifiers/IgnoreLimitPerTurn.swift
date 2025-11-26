//
//  IncrementCardsPerTurn.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

@testable import GameFeature

extension GameFeature.Action.QueueModifier {
    static let ignoreLimitPerTurn = GameFeature.Action.QueueModifier(rawValue: "ignoreLimitPerTurn")
}

struct IgnoreLimitPerTurn: QueueModifierHandler {
    static let id = GameFeature.Action.QueueModifier.ignoreLimitPerTurn

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
        fatalError("Unimplemented")
    }
}
