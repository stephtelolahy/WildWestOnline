//
//  EffectEvaluateAttribute.swift
//
//
//  Created by Hugues Telolahy on 03/09/2023.
//

struct EffectEvaluateAttribute: EffectResolverProtocol {
    let key: AttributeKey

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.get(.target)
        let playerObj = state.player(player)

        guard var expectedValue = playerObj.setupAttributes[key] else {
            fatalError("undefined initial value for key \(key)")
        }

        for card in playerObj.inPlay.cards {
            let cardName = card.extractName()
            if let cardObj = state.cardRef[cardName],
                let value = cardObj.attributes[key] {
                expectedValue = value
            }
        }

        let actualValue = playerObj.attributes[key]
        guard actualValue != expectedValue else {
            return []
        }

        return [.setAttribute(key, value: expectedValue, player: player)]
    }
}
