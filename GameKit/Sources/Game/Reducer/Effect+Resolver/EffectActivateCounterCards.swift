//
//  EffectActivateCounterCards.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

struct EffectActivateCounterCards: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let playerObj = state.player(ctx.actor)
        let playReqContext = PlayReqContext(actor: ctx.actor, event: ctx.event)

        var counterOptions: [String: GameAction] = [:]
        for card in playerObj.hand {
            if CounterActionResolver.isCounterCard(card, player: ctx.actor, state: state, ctx: playReqContext) {
                counterOptions[card] = .play(card, player: ctx.actor)
            }
        }

        guard counterOptions.isNotEmpty else {
            return []
        }

        counterOptions[.pass] = .nothing

        let chooseOne = try GameAction.validateChooseOne(
            chooser: ctx.actor,
            options: counterOptions,
            state: state
        )
        return [chooseOne]
    }
}

private enum CounterActionResolver {
    static func isCounterCard(_ card: String, player: String, state: GameState, ctx: PlayReqContext) -> Bool {
        var cardName = card.extractName()

        // resolve card alias>
        if let alias = state.alias(for: card, player: player, ctx: ctx) {
            cardName = alias
        }
        // </resolve card alias>

        guard let cardObj = state.cardRef[cardName] else {
            return false
        }

        guard cardObj.rules.contains(where: {
            if $0.playReqs.contains(.play),
               case .counterShoot = $0.effect {
                return true
            } else {
                return false
            }
        }) else {
            return false
        }

        return true
    }
}
