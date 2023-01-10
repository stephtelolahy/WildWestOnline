//
//  EffectResolverHeal.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

struct EffectResolverHeal: EffectResolver {
    
    func resolve(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .heal(player, value) = effect else {
            fatalError("unexpected effect type \(effect)")
        }
        
        guard case let .id(playerId) = player else {
            fatalError("player not resolved \(player)")
        }
        
        guard var playerObj = ctx.players[playerId] else {
            fatalError("player not found \(playerId)")
        }
        
        guard playerObj.health < playerObj.maxHealth else {
            return .failure(.playerAlreadyMaxHealth(playerId))
        }
        
        let newHealth = min(playerObj.health + value, playerObj.maxHealth)
        playerObj.health = newHealth
        
        var state = ctx
        state.players[playerId] = playerObj
        
        return .success(EffectOutputImpl(state: state))
    }
    
}
