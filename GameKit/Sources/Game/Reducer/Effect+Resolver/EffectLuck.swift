//
//  EffectLuck.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 22/06/2023.
//
import Foundation

struct EffectLuck: EffectResolver {
    let regex: String
    let onSuccess: CardEffect
    let onFailure: CardEffect?
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        // repeat luck according to actor's `flippedCards` attribute
        let player = ctx.get(.actor)
        let playerObj = state.player(player)
        guard let flippedCards = playerObj.attributes[.flippedCards] else {
            fatalError("missing attribute flippedCards")
        }

        guard flippedCards > 0 else {
            fatalError("invalid flippedCards \(flippedCards)")
        }

        var result: [GameAction] = []
        var state = state
        var matched = false
        for _ in (0..<flippedCards) {
            result.append(.luck)
            let card = try state.popDeck()
            if card.matches(regex: regex) {
                matched = true
            }
        }
        
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

private  extension String {
    func matches(regex pattern: String) -> Bool {
        if #available(iOS 16.0, *) {
            if let regex = try? Regex(pattern),
               self.ranges(of: regex).isNotEmpty {
                return true
            } else {
                return false
            }
        } else {
            // Fallback on earlier versions
            fatalError("unimplemented")
        }
    }
}
