//
//  SetTurn.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Set turn
public struct SetTurn: Effect, Equatable {
    private let player: ArgPlayer
    
    public init(player: ArgPlayer) {
        self.player = player
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .id(playerId) = player else {
            return ArgResolverPlayer.resolve(player, ctx: ctx) {
                Self(player: .id($0))
            }
        }
        
        var ctx = ctx
        ctx.turn = playerId
        ctx.played = []
        
        return .success(EffectOutputImpl(state: ctx))
    }
}
