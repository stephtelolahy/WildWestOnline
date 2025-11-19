//
//  GameFeatureState+Alias.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/11/2025.
//

extension GameFeature.State {
    func playAlias(for card: String, player: String) -> String? {
        let playerObj = players.get(player)
        for ability in playerObj.abilities {
            let abilityCard = cards.get(ability)
            for effect in abilityCard.effects {
                if effect.trigger == .permanent,
                   effect.action == .setPlayAlias,
                   let playAlias = effect.playAlias {
                    if let aliasName = playAlias[card] {
                        let cardObj = cards.get(aliasName)
                        let onPreparePlay = cardObj.effects.filter { $0.trigger == .cardPrePlayed }
                        if onPreparePlay.isNotEmpty {
                            return aliasName
                        }
                    }
                }
            }
        }
        return nil
    }

    func effectAlias(for card: String, player: String) -> String? {
        let playerObj = players.get(player)
        for ability in playerObj.abilities {
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
