//
//  GameState+CardAlias.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 23/11/2023.
//

extension GameState {
    func alias(for card: String, player: String, ctx: PlayReqContext) -> String? {
        let state = self
        let playerObj = self.player(player)
        let figure = playerObj.figure
        guard let cardAlias = self.cardRef[figure]?.alias,
              let matched = cardAlias.first(where: {
                  card.matches(regex: $0.regex)
                  && $0.playReqs.allSatisfy({ $0.match(state: state, ctx: ctx) })
              }) else {
            return nil
        }

        return matched.card
    }
}
