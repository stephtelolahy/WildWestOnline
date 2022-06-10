//
//  SetTurn.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// Set turn
public struct SetTurn: Effect {
    
    private let player: String
    
    public init(player: String) {
        assert(!player.isEmpty)
        
        self.player = player
    }
    
    public func resolve(ctx: State, actor: String, selectedArg: String?) -> EffectResult {
        guard Args.isPlayerResolved(player, ctx: ctx) else {
            return Args.resolvePlayer(player,
                                      copyWithPlayer: { SetTurn(player: $0) },
                                      ctx: ctx,
                                      actor: actor,
                                      selectedArg: selectedArg)
        }
        
        var state = ctx
        state.turn = player
        state.turnPlayed = []
        
        return .success(state)
    }
}
