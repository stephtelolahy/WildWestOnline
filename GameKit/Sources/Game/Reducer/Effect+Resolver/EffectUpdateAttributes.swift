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
        let figure = playerObj.name
        let defaultAttributes = state.cardRef[figure]?.attributes ?? [:]
        var result: [GameAction] = []
        let keys = state.updatableAttributes(player: playerObj)

        for key in keys {
            var expectedValue: Int? = defaultAttributes[key]
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

private extension GameState {

    func updatableAttributes(player: Player) -> [String] {
        AttributeKey.priorities
            .filter { isAttributeUpdatable($0, player: player) }
    }

    func isAttributeUpdatable(_ key: String, player: Player) -> Bool {
        if player.attributes[key] != nil {
            return true
        }

        for card in player.inPlay.cards {
            let cardName = card.extractName()
            if let cardObj = self.cardRef[cardName],
               cardObj.attributes[key] != nil {
                return true
            }
        }

        return false
    }
}
