//
//  CardSelectArena.swift
//  
//
//  Created by Hugues Telolahy on 11/04/2023.
//

struct CardSelectArena: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        let cards = state.arena
        if cards.count == 1 {
            return .identified(cards)
        } else {
            return .selectable(cards.toCardOptions())
        }
    }
}
