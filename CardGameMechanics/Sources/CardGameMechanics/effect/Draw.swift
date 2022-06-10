//
//  Draw.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// draw a card from top deck
public struct Draw: Effect {
    
    private let target: String
    
    private let times: String?
    
    public init(target: String = Args.playerActor, times: String? = nil) {
        assert(!target.isEmpty)
        
        self.target = target
        self.times = times
    }
    
    public func resolve(ctx: State, actor: String, selectedArg: String?) -> EffectResult {
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Draw(target: $0, times: times) },
                                      ctx: ctx,
                                      actor: actor,
                                      selectedArg: selectedArg)
        }
        
        if let times = times {
            let value = Args.resolveNumber(times, actor: actor, ctx: ctx)
            guard value > 0 else {
                return .nothing
            }
            
            let effects = (0..<value).map { _ in Draw(target: target) }
            return .resolving(effects)
        }
        
        var state = ctx
        var player = state.player(target)
        let card = state.removeTopDeck()
        player.hand.append(card)
        state.players[target] = player
        
        return .success(state)
    }
}
