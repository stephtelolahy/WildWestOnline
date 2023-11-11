//
//  EffectCancelTurn.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 07/11/2023.
//

struct EffectCancelEffectOfCard: EffectResolver {
    let cardName: String

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let effects = state.queue.filter {
            $0.isEffectOfCard(cardName)
        }
        return effects.map { .cancel($0) }
    }
}
