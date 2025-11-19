//
//  GameFeatureState+PlayAlias.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/11/2025.
//

extension GameFeature.State {
    func playCardAlias(for card: String, player: String) -> String? {
        let playerObj = players.get(player)
        for ability in playerObj.abilities {
            let abilityCard = cards.get(ability)
            for effect in abilityCard.effects {
                if effect.trigger == .permanent,
                   effect.action == .setCardAlias,
                   let cardAlias = effect.cardAlias {
                    if let aliasCardName = cardAlias[card] {
                        let cardObj = cards.get(aliasCardName)
                        let onPreparePlay = cardObj.effects.filter { $0.trigger == .cardPrePlayed }
                        if onPreparePlay.isNotEmpty {
                            return aliasCardName
                        }
                    }
                }
            }
        }
        return nil
    }
}
