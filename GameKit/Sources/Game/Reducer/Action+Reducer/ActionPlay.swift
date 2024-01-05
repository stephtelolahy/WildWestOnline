//
//  ActionPlay.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlay: GameActionReducer {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        // <resolve card alias>
        var cardName = card.extractName()
        let event = GameAction.play(card, player: player)
        let playReqContext = PlayReqContext(actor: player, event: event)
        if let alias = state.alias(for: card, player: player, ctx: playReqContext) {
            cardName = alias
        }
        // </resolve card alias>

        guard let cardObj = state.cardRef[cardName],
              let playRule = cardObj.rules.first(where: { $0.playReqs.contains(.play) }) else {
            throw GameError.cardNotPlayable(card)
        }

        // verify requirements
        for playReq in playRule.playReqs where playReq != .play {
            try playReq.throwingMatch(state: state, ctx: playReqContext)
        }

        // queue play effects
        var state = state
        state.incrementPlayedThisTurn(for: card)

        let cardEffect = playRule.effect
        let ctx = EffectContext(
            actor: player,
            card: card,
            event: event
        )

        state.sequence.insert(.effect(cardEffect, ctx: ctx), at: 0)
        return state
    }
}
