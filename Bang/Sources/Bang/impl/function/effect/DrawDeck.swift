//
//  DrawDeck.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Draw top deck card
public struct DrawDeck: Effect, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableIgnore public var playCtx: PlayContext = PlayContextImpl()
    
    public init(player: ArgPlayer) {
        self.player = player
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0))
            }
        }
        
        var playerObj = ctx.player(playerId)
        var ctx = ctx
        let card = ctx.removeTopDeck()
        playerObj.hand.append(card)
        ctx.players[playerId] = playerObj
        
        return .success(EventOutputImpl(state: ctx))
    }
}
