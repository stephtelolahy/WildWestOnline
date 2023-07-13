//
//  CardSelectArena.swift
//  
//
//  Created by Hugues Telolahy on 11/04/2023.
//

struct CardSelectArena: CardArgResolverProtocol {
    func resolve(
        state: GameState,
        ctx: EffectContext,
        chooser: String,
        owner: String?
    ) -> CardArgOutput {
        let cards = state.arena?.cards ?? []
        if cards.count == 1 {
            return .identified(cards)
        } else {
            return .selectable(cards.toCardOptions())
        }
    }
}
