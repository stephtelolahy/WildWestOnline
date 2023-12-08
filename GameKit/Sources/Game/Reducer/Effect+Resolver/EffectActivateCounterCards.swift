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

        let counterOptions = playerObj.hand.compactMap {
            CounterActionResolver.counterAction(card: $0, player: ctx.actor, state: state, ctx: playReqContext)
        }

        guard counterOptions.isNotEmpty else {
            return []
        }

        var options = counterOptions.reduce(into: [String: GameAction]()) {
            $0[$1.card] = $1.action
        }
        options[.pass] = .nothing

        let chooseOne = try GameAction.validateChooseOne(
            chooser: ctx.actor,
            options: options,
            state: state
        )
        return [chooseOne]
    }
}

private struct CounterOption {
    let card: String
    let action: GameAction
}

private enum CounterActionResolver {
    static func counterAction(card: String, player: String, state: GameState, ctx: PlayReqContext) -> CounterOption? {
        var cardName = card.extractName()
        var aliasCardName: String?

        // resolve card alias>
        if let alias = state.alias(for: card, player: player, ctx: ctx) {
            cardName = alias
            aliasCardName = alias
        }
        // </resolve card alias>

        guard let cardObj = state.cardRef[cardName] else {
            return nil
        }

        guard cardObj.rules.contains(where: {
            if $0.playReqs.contains(.playImmediate),
               case .counterShoot = $0.effect {
                return true
            } else {
                return false
            }
        }) else {
            return nil
        }

        let action: GameAction = if let aliasCardName {
            .playAs(aliasCardName, card: card, player: player)
        } else {
            .playImmediate(card, player: player)
        }

        return CounterOption(card: card, action: action)
    }
}
