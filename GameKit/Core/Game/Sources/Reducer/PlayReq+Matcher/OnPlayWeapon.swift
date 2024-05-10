//
//  OnPlayWeapon.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 07/09/2023.
//

struct OnPlayWeapon: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        guard case let .equip(playedCard, player) = ctx.event,
              player == ctx.actor else {
            return false
        }

        let cardName = playedCard.extractName()
        guard let cardObj = state.cards[cardName],
              cardObj.attributes.keys.contains(.weapon) else {
            return false
        }

        return true
    }
}
