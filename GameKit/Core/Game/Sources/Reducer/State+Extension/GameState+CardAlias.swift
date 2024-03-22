//
//  GameState+CardAlias.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 23/11/2023.
//

extension GameState {
    func aliasWhenPlayingCard(_ card: String, player: String, ctx: PlayReqContext) -> String? {
        let state = self
        let playerObj = state.player(player)
        let figure = playerObj.figure
        guard let cardAlias = state.cardRef[figure]?.abilityToPlayCardAs,
              let matched = cardAlias.first(where: {
                  card.matches(regex: $0.playedRegex)
                  && $0.playReqs.allSatisfy({ $0.match(state: state, ctx: ctx) })
              }) else {
            return nil
        }

        return matched.effectCard
    }
}
