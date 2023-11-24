//
//  GameState+CardAlias.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 23/11/2023.
//

extension GameState {
    func alias(for card: String, player: String) -> String? {
        let playerObj = self.player(player)
        let figure = playerObj.figure
        let cardAlias = self.cardRef[figure]?.alias ?? []
        guard let matched = cardAlias.first(where: {
            card.matches(regex: $0.regex)
        }) else {
            return nil
        }

        return matched.card
    }
}
