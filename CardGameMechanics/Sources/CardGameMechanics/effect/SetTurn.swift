//
//  SetTurn.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// Set turn
public struct SetTurn: Effect, Equatable {
    let player: String
    
    @EquatableNoop
    public var ctx: [ContextKey: Any]
    
    public init(player: String, ctx: [ContextKey: Any] = [:]) {
        assert(!player.isEmpty)
        
        self.player = player
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copy: { SetTurn(player: $0, ctx: ctx) },
                                      ctx: ctx,
                                      state: state)
        }
        
        var state = state
        state.turn = player
        state.played = []
        
        return .success(EffectOutput(state: state))
    }
}
