//
//  DrawDeck.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Draw top deck card
public struct DrawDeck: Effect, Equatable {
    
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
        
        var playerObj = ctx.player(playerId)
        var ctx = ctx
        let card = ctx.removeTopDeck()
        playerObj.hand.append(card)
        ctx.players[playerId] = playerObj
        
        return .success(EffectOutputImpl(state: ctx))
    }
}
