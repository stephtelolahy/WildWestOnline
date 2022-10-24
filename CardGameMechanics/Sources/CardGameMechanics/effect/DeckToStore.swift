//
//  DeckToStore.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 10/06/2022.
//
import CardGameCore

/// Draw card from deck to choosable zone
public struct DeckToStore: Effect {
    let times: String?
    
    public init(times: String? = nil) {
        self.times = times
    }
    
    public func resolve(in state: State, ctx: [EffectKey: any Equatable]) -> Result<EffectOutput, Error> {
        if let times {
            return Args.resolveNumber(times, copy: { DeckToStore() }, ctx: ctx, state: state)
        }
        
        var state = state
        let card = state.removeTopDeck()
        state.store.append(card)
        
        return .success(EffectOutput(state: state))
    }
}
