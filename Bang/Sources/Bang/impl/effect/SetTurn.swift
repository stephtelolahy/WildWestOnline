//
//  SetTurn.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Set turn
public struct SetTurn: Effect, Equatable {
    @EquatableCast private var player: ArgPlayer
    
    public init(player: ArgPlayer) {
        self.player = player
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0))
            }
        }
        
        var ctx = ctx
        ctx.turn = playerId
        ctx.played = []
        
        return .success(EffectOutputImpl(state: ctx))
    }
}
