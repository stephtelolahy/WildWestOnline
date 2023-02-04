//
//  Damage.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore
import ExtensionsKit

/// Deals damage to a player, attempting to reduce its Health by the stated amount
public struct Damage: Event, Equatable {
    @EquatableCast var player: ArgPlayer
    private let value: Int
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    // swiftlint:disable:next function_default_parameter_at_end
    public init(player: ArgPlayer = PlayerActor(), value: Int) {
        self.player = player
        self.value = value
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        assert(value > 0)
        
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0), value: value)
            }
        }
        
        var ctx = ctx
        var playerObj = ctx.player(playerId)
        playerObj.health -= value
        ctx.players[playerId] = playerObj
        
        return .success(EventOutputImpl(state: ctx))
    }
}
