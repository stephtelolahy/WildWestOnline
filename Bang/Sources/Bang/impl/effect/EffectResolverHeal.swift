//
//  EffectResolverHeal.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

struct EffectResolverHeal: EffectResolver {
    let resolverPlayer: ArgResolverPlayer
    
    func resolve(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .heal(player, value) = effect else {
            fatalError("unexpected effect type \(effect)")
        }
        
        guard case let .id(playerId) = player else {
            return resolverPlayer.resolve(player, ctx: ctx) {
                .heal(player: .id($0), value: value)
            }
        }
        
        guard var playerObj = ctx.players[playerId] else {
            fatalError("player not found \(playerId)")
        }
        
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
