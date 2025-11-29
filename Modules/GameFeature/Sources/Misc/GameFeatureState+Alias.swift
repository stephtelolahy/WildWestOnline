//
//  GameFeatureState+Alias.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/11/2025.
//

extension GameFeature.State {
    func alias(for card: String, player: String, actionName: Card.ActionName) -> String? {
        let playerObj = players.get(player)
        let abilities = playerObj.figure + auras
        for ability in abilities {
            let abilityCard = cards.get(ability)
            for effect in abilityCard.effects {
                if effect.trigger == .permanent,
                   effect.action == .setAlias,
                   let effectAlias = effect.alias,
                   let aliasCardName = effectAlias[card] {
                    let aliasCardObj = cards.get(aliasCardName)
                    if let mainEffect = aliasCardObj.effects.first(where: { $0.trigger == .cardPlayed || $0.trigger == .cardPrePlayed })?.action {
                        if mainEffect == actionName {
                            return aliasCardName
                        }
                    }
                }
            }
        }
        return nil
    }
}
