//
//  EffectUpdateAttributes.swift
//
//
//  Created by Hugues Telolahy on 03/09/2023.
//

struct EffectUpdateAttributes: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        /*
        let player = ctx.targetOrActor()
        let playerObj = state.player(player)
        let figure = playerObj.figure
        let figureAttributes = state.cards[figure]?.playerAttributes ?? [:]
        var children: [GameAction] = []

        for key in PlayerAttribute.allCases {
            var expectedValue: Int? = figureAttributes[key]
            for card in state.field.inPlay.get(player) {
                let cardName = card.extractName()
                if let cardObj = state.cards[cardName],
                   let value = cardObj.playerAttributes[key] {
                    expectedValue = value
                }
            }

            let actualValue = playerObj.attributes[key]
            if actualValue != expectedValue {
                children.append(.setAttribute(key, value: expectedValue, player: player))
            }
        }

        return .push(children)
         */
        fatalError()
    }
}
