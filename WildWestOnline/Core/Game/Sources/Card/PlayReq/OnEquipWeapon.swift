//
//  OnEquipWeapon.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 07/09/2023.
//

struct OnEquipWeapon: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        guard case let .playEquipment(playedCard, player) = ctx.event,
              player == ctx.actor else {
            return false
        }

        let cardName = playedCard.extractName()
        guard let cardObj = state.cards[cardName],
              cardObj.playerAttributes.keys.contains(.weapon) else {
            return false
        }

        return true
    }
}
