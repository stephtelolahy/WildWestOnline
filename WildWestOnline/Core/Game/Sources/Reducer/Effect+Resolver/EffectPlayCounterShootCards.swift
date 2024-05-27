//
//  EffectPlayCounterCards.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

struct EffectPlayCounterShootCards: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let playerObj = state.player(ctx.sourceActor)
        let playReqContext = PlayReqContext(actor: ctx.sourceActor, event: ctx.sourceEvent)

        let counterCards = playerObj.hand.filter {
            Self.isCounterShootCard(
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
        return try GameAction.validateChooseOne(
            options,
            actions: actions,
            chooser: ctx.sourceActor,
            type: .cardToPlayCounter,
            state: state,
            ctx: ctx
        )
    }
}

private extension EffectPlayCounterShootCards {
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
