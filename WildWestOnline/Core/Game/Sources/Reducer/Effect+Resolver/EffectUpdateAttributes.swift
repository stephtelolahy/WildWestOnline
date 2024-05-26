//
//  EffectUpdateAttributes.swift
//
//
//  Created by Hugues Telolahy on 03/09/2023.
//

struct EffectUpdateAttributes: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.targetOrActor()
        let playerObj = state.player(player)
        let figure = playerObj.figure
        let figureAttributes = state.cards[figure]?.attributes ?? [:]
        var result: [GameAction] = []

        for key in state.updatableAttributes(of: playerObj) {
            var expectedValue: Int? = figureAttributes[key]
            for card in playerObj.inPlay {
                let cardName = card.extractName()
                if let cardObj = state.cards[cardName],
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

private extension GameState {
    func updatableAttributes(of player: Player) -> [String] {
        var result: Set<String> = Set(player.attributes.keys)
        for card in player.inPlay {
            let cardName = card.extractName()
            if let cardObj = cards[cardName] {
                result = result.union(cardObj.attributes.keys)
            }
        }
        return Array(result).sorted()
    }
}
