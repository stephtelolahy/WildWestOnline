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
    
    public func resolve(state: State, ctx: PlayContext) -> EffectResult {
        guard Args.isPlayerResolved(target, state: state) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Draw(target: $0, times: times) },
                                      state: state,
                                      ctx: ctx)
        }
        
        if let times {
            return Args.resolveNumber(times, copy: { Draw(target: target) }, actor: ctx.actor, state: state)
        }
        
        var state = state
        var player = state.player(target)
        let card = state.removeTopDeck()
        player.hand.append(card)
        state.players[target] = player
        
        return .success(state)
    }
}
