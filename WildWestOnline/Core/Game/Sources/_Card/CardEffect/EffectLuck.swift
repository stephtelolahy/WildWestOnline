//
//  EffectLuck.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 22/06/2023.
//

import Foundation

struct EffectLuck: EffectResolver {
    let card: ArgLuckCard
    let regex: String
    let onSuccess: CardEffect
    let onFailure: CardEffect?

    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        /*
        var result: [GameAction] = []
        let player = ctx.sourceActor
        let playerObj = state.player(player)

        let drawnCards: [String]
        switch card {
        case .drawnHand:
            let handlCards = state.field.hand.get(player)
            guard let lastHandCard = handlCards.last else {
                fatalError("missing drawn card")
            }

            drawnCards = [lastHandCard]

        case .drawn:
            guard let flippedCards = playerObj.attributes[.flippedCards] else {
                fatalError("missing attribute flippedCards")
            }

            guard flippedCards > 0 else {
                fatalError("invalid flippedCards \(flippedCards)")
            }

            guard state.discard.count >= flippedCards else {
                fatalError("missing drawn card")
            }

            drawnCards = Array(state.discard.prefix(flippedCards))
        }

        let matched = drawnCards.contains { $0.matches(regex: regex) }
        if matched {
            result.append(.prepareEffect(onSuccess, ctx: ctx))
        } else {
            if let onFailure {
                result.append(.prepareEffect(onFailure, ctx: ctx))
            }
        }

        return .push(result)
         */
        fatalError()
    }
}
