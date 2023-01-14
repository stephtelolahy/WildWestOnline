//
//  Eliminate.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

/// Remove player from game
public struct Eliminate: Effect, Equatable {
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
        ctx.playOrder.removeAll(where: { $0 == playerId })
        return .success(EffectOutputImpl(state: ctx))
    }
}
