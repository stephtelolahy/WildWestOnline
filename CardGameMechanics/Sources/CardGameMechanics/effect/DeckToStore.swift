//
//  DeckToStore.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 10/06/2022.
//
import CardGameCore

/// Draw card from deck to choosable zone
public struct DeckToStore: Effect, Equatable {
    let times: String?
    
    @EquatableNoop
    public var ctx: [String: Any]
    
    public init(times: String? = nil, ctx: [String: Any] = [:]) {
        self.times = times
        self.ctx = ctx
    }
    
    public func resolve(in state: CardGameCore.State) -> Result<CardGameCore.EffectOutput, Error> {
        if let times {
            return Args.resolveNumber(times, copy: { DeckToStore() }, ctx: ctx, state: state)
        }
        
        var state = state
        let card = state.removeTopDeck()
        state.store.append(card)
        
        return .success(EffectOutput(state: state))
    }
}
