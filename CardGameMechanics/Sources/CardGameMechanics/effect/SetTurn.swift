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
        self.player = player
    }
    
    public func canResolve(ctx: State, actor: String) -> Result<Void, Error> {
        .success
    }
    
    public func resolve(ctx: State, cardRef: String) -> Result<State, Error> {
        guard Args.isPlayerResolved(player, ctx: ctx) else {
            return Args.resolvePlayer(player,
                                      copyWithTarget: { SetTurn(player: $0) },
                                      ctx: ctx,
                                      cardRef: cardRef)
        }
        
        var state = ctx
        state.turn = player
        state.turnPlayed = []
        state.lastEvent = self
        
        return .success(state)
    }
}
