//
//  OnPlayEquipmentWithAttribute.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 07/09/2023.
//

struct OnPlayEquipmentWithAttribute: PlayReqMatcherProtocol {
    let key: AttributeKey

    func match(state: GameState, ctx: EffectContext) -> Bool {
        guard case let .playEquipment(playedCard, player) = state.event,
              player == ctx.get(.actor) else {
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