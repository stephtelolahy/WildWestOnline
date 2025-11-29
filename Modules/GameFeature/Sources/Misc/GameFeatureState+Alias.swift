//
//  GameFeatureState+Alias.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/11/2025.
//

extension GameFeature.State {
    func alias(for card: String, player: String) -> String? {
        let playerObj = players.get(player)
        let abilities = playerObj.figure + auras
        for ability in abilities {
            let abilityCard = cards.get(ability)
            for effect in abilityCard.effects {
                if effect.trigger == .permanent,
                   effect.action == .setAlias,
                   let effectAlias = effect.alias {
                    if let aliasName = effectAlias[card] {
                        return aliasName
                    }
                }
            }
        }
        return nil
    }

    func effectAlias(for card: String, player: String) -> String? {
        let playerObj = players.get(player)
        let abilities = playerObj.figure + auras
        for ability in abilities {
            let abilityCard = cards.get(ability)
            for effect in abilityCard.effects {
                if effect.trigger == .permanent,
                   effect.action == .setEffectAlias,
                   let effectAlias = effect.effectAlias {
                    if let aliasName = effectAlias[card] {
                        return aliasName
                    }
                }
            }
        }
        return nil
    }
}
