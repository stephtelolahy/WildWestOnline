//
//  SetTurn.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// Set turn
public struct SetTurn: Effect {
    let player: String
    
    public init(player: String) {
        assert(!player.isEmpty)
        
        self.player = player
    }
    
    public func resolve(in state: State, ctx: [String: String]) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copyWithPlayer: { SetTurn(player: $0) },
                                      ctx: ctx,
                                      state: state)
        }
        
        var state = state
        state.turn = player
        state.played = []
        
        return .success(EffectOutput(state: state))
    }
}
