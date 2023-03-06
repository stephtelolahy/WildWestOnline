//
//  Eliminate.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
import GameCore
import GameUtils

/// Remove player from game
public struct Eliminate: Event, Equatable {
    @EquatableCast var player: ArgPlayer
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(player: ArgPlayer = PlayerActor()) {
        self.player = player
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0))
            }
        }
        
        var ctx = ctx
        ctx.playOrder.removeAll(where: { $0 == playerId })
        return .success(EventOutputImpl(state: ctx))
    }
}
