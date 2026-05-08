//
//  GameFeatureState+Alias.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/11/2025.
//
extension GameFeature.State {
    func alias(
        for card: String,
        player: String,
        action: Card.ActionName,
        on trigger: Card.Trigger
    ) -> String? {
        let playerObj = players.get(player)
        let abilities = playerObj.figure + auras
        for ability in abilities {
            let abilityCard = cards.get(ability)
            for effect in abilityCard.effects {
                if effect.trigger == .permanent,
                   effect.action == .setAlias,
                   let effectAlias = effect.alias,
                   effectAlias.played == card {
                    let aliasCardName = effectAlias.alias
                    let aliasCardObj = cards.get(aliasCardName)
                    if let effectName = aliasCardObj.effects.first(where: { $0.trigger == trigger })?.action,
                       effectName == action {
                        return aliasCardName
                    }
                }
            }
        }
        return nil
    }
}
