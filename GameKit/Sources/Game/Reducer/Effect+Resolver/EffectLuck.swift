//
//  EffectLuck.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 22/06/2023.
//

import Foundation

struct EffectLuck: EffectResolver {
    let card: ArgCardLuck
    let regex: String
    let onSuccess: CardEffect
    let onFailure: CardEffect?

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        var result: [GameAction] = []
        let player = ctx.actor
        let playerObj = state.player(player)

        let drawnCards: [String]
        switch card {
        case .lastHand:
            guard let lastHandCard = playerObj.hand.last else {
                fatalError("missing drawn card")
            }

            drawnCards = [lastHandCard]
            result.append(.revealHand(lastHandCard, player: player))

        case .topDiscard:
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
            result.append(.effect(onSuccess, ctx: ctx))
        } else {
            if let onFailure {
                result.append(.effect(onFailure, ctx: ctx))
            }
        }

        return result
    }
}
