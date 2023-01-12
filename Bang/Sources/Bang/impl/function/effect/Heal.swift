//
//  Heal.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Restore character's health, limited to maxHealth
public struct Heal: Effect, Equatable {
    @EquatableCast private var player: ArgPlayer
    private let value: Int
    
    public init(player: ArgPlayer, value: Int) {
        self.player = player
        self.value = value
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0), value: value)
            }
        }
        
        var playerObj = ctx.player(playerId)
        guard playerObj.health < playerObj.maxHealth else {
            return .failure(.playerAlreadyMaxHealth(playerId))
        }
        
        let newHealth = min(playerObj.health + value, playerObj.maxHealth)
        playerObj.health = newHealth
        
        var ctx = ctx
        ctx.players[playerId] = playerObj
        
        return .success(EffectOutputImpl(state: ctx))
    }
}
