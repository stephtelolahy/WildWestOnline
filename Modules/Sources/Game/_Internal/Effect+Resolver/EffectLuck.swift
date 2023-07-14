//
//  EffectLuck.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 22/06/2023.
//
import Foundation

struct EffectLuck: EffectResolverProtocol {
    let regex: String
    let onSuccess: CardEffect
    let onFailure: CardEffect?
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        guard let card = state.deck.top else {
            throw GameError.deckIsEmpty
        }
        
        var result: [GameAction] = [.luck]
        
        let matched = card.matches(regex: regex)
        if matched {
            result.append(.resolve(onSuccess, ctx: ctx))
        } else {
            if let onFailure {
                result.append(.resolve(onFailure, ctx: ctx))
            }
        }
        
        return result
    }
}

private  extension String {
    func matches(regex pattern: String) -> Bool {
        if let regex = try? Regex(pattern),
            self.ranges(of: regex).isNotEmpty {
            true
        } else {
            false
        }
    }
}
