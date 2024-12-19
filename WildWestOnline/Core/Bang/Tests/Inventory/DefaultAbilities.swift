//
//  DefaultAbilities.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 01/12/2024.
//

enum DefaultAbilities {
    static var all: [String] {
        [
            .defaultEndTurn,
            .defaultDiscardExcessHandOnTurnEnded,
            .defaultDraw2CardsOnTurnStarted,
            .defaultStartTurnNextOnTurnEnded,
            .defaultEliminateOnDamageLethal,
            .defaultEndGameOnEliminated,
            .defaultDiscardAllCardsOnEliminated,
            .defaultEndTurnOnEliminated
        ]
    }
}
