//
//  EffectUpdateAttributes.swift
//
//
//  Created by Hugues Telolahy on 03/09/2023.
//

struct EffectUpdateAttributes: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.player()
        let playerObj = state.player(player)
        let figure = playerObj.figure
        let figureAttributes = state.cardRef[figure]?.attributes ?? [:]
        var result: [GameAction] = []

        for key in AttributeKey.allCases {
            var expectedValue: Int? = figureAttributes[key]
            for card in playerObj.inPlay {
                let cardName = card.extractName()
                if let cardObj = state.cardRef[cardName],
                   let value = cardObj.attributes[key] {
                    expectedValue = value
                }
            }

            let actualValue = playerObj.attributes[key]
            if actualValue != expectedValue {
                if let expectedValue {
                    result.append(.setAttribute(key, value: expectedValue, player: player))
                } else {
                    result.append(.removeAttribute(key, player: player))
                }
            }
        }

        return result
    }
}
