//
//  IncrementCardsPerTurnModifier.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

import GameFeature

extension GameFeature.Action.Modifier {
    static let incrementCardsPerTurn = GameFeature.Action.Modifier(rawValue: "incrementCardsPerTurn")
}

struct IncrementCardsPerTurnModifier: ModifierHandler {
    static let id = GameFeature.Action.Modifier.incrementCardsPerTurn

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> GameFeature.State {
        state
    }
}
