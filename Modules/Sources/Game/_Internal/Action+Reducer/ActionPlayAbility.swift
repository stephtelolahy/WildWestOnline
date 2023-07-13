//
//  ActionPlayAbility.swift
//  
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlayAbility: GameReducerProtocol {
    let actor: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let playAction = cardObj.actions.first(where: { $0.eventReq == .onPlay }) else {
            throw GameError.cardNotPlayable(card)
        }

        let ctx: EffectContext = [.actor: actor, .card: card]

        let sideEffect = playAction.effect
        
        var state = state

        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1
        
        state.queue.insert(.resolve(sideEffect, ctx: ctx), at: 0)
        return state
    }
}
