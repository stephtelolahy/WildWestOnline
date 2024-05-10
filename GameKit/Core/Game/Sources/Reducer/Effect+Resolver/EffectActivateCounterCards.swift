//
//  EffectActivateCounterCards.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

struct EffectActivateCounterCards: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let playerObj = state.player(ctx.sourceActor)
        let playReqContext = PlayReqContext(actor: ctx.sourceActor, event: ctx.sourceEvent)

        let counterCards = playerObj.hand.filter {
            CounterActionResolver.isCounterShootCard(
                $0,
                player: ctx.sourceActor,
                state: state,
                ctx: playReqContext
            )
        }

        guard counterCards.isNotEmpty else {
            return []
        }

        var actions = counterCards.reduce(into: [String: GameAction]()) {
            $0[$1] = .play($1, player: ctx.sourceActor)
        }

        actions[.pass] = .nothing

        let options = counterCards + [.pass]
        let validoptions = try GameAction.validateOptions(
            options,
            actions: actions,
            state: state
        )

        let chooseOne = GameAction.chooseOne(
            .counterCard,
            options: validoptions,
            player: ctx.sourceActor
        )

        let match = GameAction.effect(.matchAction(actions), ctx: ctx)

        return [chooseOne, match]
    }
}

private enum CounterActionResolver {
    static func isCounterShootCard(
        _ card: String,
        player: String,
        state: GameState,
        ctx: PlayReqContext
    ) -> Bool {
        var cardName = card.extractName()

        // <resolve card alias>
        if let alias = state.aliasWhenPlayingCard(card, player: player, ctx: ctx) {
            cardName = alias
        }
        // </resolve card alias>

        guard let cardObj = state.cards[cardName] else {
            return false
        }

        return cardObj.rules.contains {
            if $0.playReqs.contains(.play),
               case .counterShoot = $0.effect {
                return true
            } else {
                return false
            }
        }
    }
}
