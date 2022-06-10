//
//  DeckToStore.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 10/06/2022.
//
import CardGameCore

/// Draw card from deck to choosable zone
public struct DeckToStore: Effect {
    
    private let times: String?
    
    public init(times: String? = nil) {
        self.times = times
    }
    
    public func resolve(state: State, ctx: PlayContext) -> EffectResult {
        if let times = self.times {
            return Args.resolveNumber(times, copy: { DeckToStore() }, actor: ctx.actor, state: state)
        }
        
        var state = state
        let card = state.removeTopDeck()
        state.store.append(card)
        
        return .success(state)
    }
}
