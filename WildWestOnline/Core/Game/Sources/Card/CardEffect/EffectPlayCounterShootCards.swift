//
//  EffectPlayCounterCards.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

struct EffectPlayCounterShootCards: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        let actor = ctx.sourceActor
        let playReqContext = PlayReqContext(actor: ctx.sourceActor, event: ctx.sourceEvent)

        let counterCards = state.field.hand.get(actor).filter {
            Self.isCounterShootCard(
                $0,
                player: ctx.sourceActor,
                state: state,
                ctx: playReqContext
            )
        }

        guard counterCards.isNotEmpty else {
            return .nothing
        }

        var actions = counterCards.reduce(into: [String: GameAction]()) {
            $0[$1] = .preparePlay($1, player: ctx.sourceActor)
        }

        actions[.pass] = .nothing

        let options = counterCards + [.pass]
        let children = try GameAction.validateChooseOne(
            options,
            actions: actions,
            chooser: ctx.sourceActor,
            type: .cardToPlayCounter,
            state: state,
            ctx: ctx
        )

        return .push(children)
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
