//
//  EffectEvaluateAttributes.swift
//
//
//  Created by Hugues Telolahy on 03/09/2023.
//

struct EffectEvaluateAttributes: EffectResolver {

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.target!
        let playerObj = state.player(player)
        var result: [GameAction] = []

        let keys = AttributeKey.allCases
        for key in keys {
            guard var expectedValue = playerObj.startAttributes[key] else {
                continue
            }

            for card in playerObj.inPlay.cards {
                let cardName = card.extractName()
                if let cardObj = state.cardRef[cardName],
                   let value = cardObj.attributes[key] {
                    expectedValue = value
                }
            }

            let actualValue = playerObj.attributes[key]
            if actualValue != expectedValue {
                result.append(.setAttribute(key, value: expectedValue, player: player))
            }
        }

        return result
    }
}
