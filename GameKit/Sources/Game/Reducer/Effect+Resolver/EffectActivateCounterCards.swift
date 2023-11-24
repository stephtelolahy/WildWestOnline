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
        let counterCards = playerObj.hand.cards.filter {
            state.isCounterCard($0, player: ctx.actor, ctx: playReqContext)
        }
        guard counterCards.isNotEmpty else {
            return []
        }

        var options = counterCards.reduce(into: [String: GameAction]()) {
            $0[$1] = GameAction.play($1, player: ctx.actor)
        }
        options[.pass] = .group([])

        let chooseOne = try GameAction.validateChooseOne(
            chooser: ctx.actor,
            options: options,
            state: state
        )
        return [chooseOne]
    }
}

private extension GameState {
    func isCounterCard(_ card: String, player: String, ctx: PlayReqContext) -> Bool {
        var cardName = card.extractName()

        // resolve card alias>
        if let alias = alias(for: card, player: player, ctx: ctx) {
            cardName = alias
        }
        // </resolve card alias>

        guard let cardObj = cardRef[cardName] else {
            return false
        }

        return cardObj.rules.contains {
            if $0.playReqs.contains(.playImmediate),
               case .counterShoot = $0.effect {
                return true
            } else {
                return false
            }
        }
    }
}
