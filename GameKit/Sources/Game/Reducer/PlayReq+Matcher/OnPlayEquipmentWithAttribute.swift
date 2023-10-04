//
//  OnPlayEquipmentWithAttribute.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 07/09/2023.
//

struct OnPlayEquipmentWithAttribute: PlayReqMatcher {
    let key: AttributeKey

    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        guard case let .playEquipment(playedCard, player) = state.event,
              player == ctx.actor else {
            return false
        }

        let cardName = playedCard.extractName()
        guard let cardObj = state.cardRef[cardName],
              cardObj.attributes.keys.contains(key) else {
            return false
        }

        return true
    }
}
