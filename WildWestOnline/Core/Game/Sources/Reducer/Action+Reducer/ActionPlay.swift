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
        if let alias = state.aliasWhenPlayingCard(card, player: player, ctx: playReqContext) {
            cardName = alias
        }
        // </resolve card alias>

        guard let cardObj = state.cards[cardName] else {
            throw SequenceState.Error.cardNotPlayable(card)
        }

        let playRules = cardObj.rules.filter { $0.playReqs.contains(.play) }
        guard playRules.isNotEmpty else {
            throw SequenceState.Error.cardNotPlayable(card)
        }

        // verify requirements
        for playRule in playRules {
            for playReq in playRule.playReqs where playReq != .play {
                try playReq.throwingMatch(state: state, ctx: playReqContext)
            }
        }

        var state = state

        // increment play counter
        state.incrementPlayedThisTurn(for: cardName)

        // queue play effects
        let ctx = EffectContext(
            sourceEvent: event,
            sourceActor: player,
            sourceCard: card
        )
        let children: [GameAction] = playRules.map { .effect($0.effect, ctx: ctx) }
        state.sequence.queue.insert(contentsOf: children, at: 0)

        return state
    }
}

private extension GameState {
    mutating func incrementPlayedThisTurn(for cardName: String) {
        sequence.played[cardName] = (sequence.played[cardName] ?? 0) + 1
    }
}
