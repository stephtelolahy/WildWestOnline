//
//  GameFeatureState+PermanentAmount.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//
extension GameFeature.State {
    /// Amount set by a permanent effect of player's figure
    func permanentAmount(of action: Card.ActionName, player: String) -> Int? {
        let playerObj = players.get(player)
        for figure in playerObj.figure {
            guard let cardObj = cards[Card.name(of: figure)] else {
                continue
            }

            for effect in cardObj.effects where effect.trigger == .permanent && effect.action == action {
                for case .amount(let value) in effect.selectors {
                    return value
                }
            }
        }

        return nil
    }
}
