//
//  EffectActivateCounterCards.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

struct EffectActivateCounterCards: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let playerObj = state.player(ctx.actor)
        let counterCards = playerObj.hand.cards.filter { state.isCardCounteringEffectOnPlay($0) }
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
    func isCardCounteringEffectOnPlay(_ card: String) -> Bool {
        let cardName = card.extractName()
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
