//
//  SetTurn.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
import ExtensionsKit

/// Set turn
public struct SetTurn: Event, Equatable {
    @EquatableCast public var player: ArgPlayer
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(player: ArgPlayer) {
        self.player = player
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0))
            }
        }
        
        var ctx = ctx
        ctx.turn = playerId
        ctx.played = []
        
        return .success(EventOutputImpl(state: ctx))
    }
}
