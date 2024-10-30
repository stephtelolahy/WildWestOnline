//
//  GameStateBuilder+Cards.swift
//  BangTests
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Bang

extension GameState {
    static func makeBuilderWithAllCards() -> Builder {
        makeBuilder().withCards(Cards.all)
    }
}
