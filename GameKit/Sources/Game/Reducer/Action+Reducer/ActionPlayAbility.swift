//
//  ActionPlayAbility.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlayAbility: GameReducerProtocol {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        // verify action
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let sideEffect = cardObj.rules.first(where: { $0.playReqs.contains(.onPlayAbility) })?.effect else {
            throw GameError.cardNotPlayable(card)
        }

        // save played card
        var state = state
        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1

        // queue sideEffect
        let ctx: EffectContext = [.actor: player, .card: card]
        state.queue.insert(.resolve(sideEffect, ctx: ctx), at: 0)
        return state
    }
}
