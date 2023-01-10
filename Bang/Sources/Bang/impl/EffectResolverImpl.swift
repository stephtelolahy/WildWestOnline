//
//  EffectResolverImpl.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

import UIKit

public struct EffectResolverImpl: EffectResolver {
    
    public init() {}
    
    public func resolve(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError> {
        switch effect {
        case let .heal(player, value):
            return resolveHeal(player: player, value: value, ctx: ctx)
            
        default:
            fatalError("unimplemented resolver for \(effect)")
        }
    }
}

private extension EffectResolverImpl {
    
    func resolveHeal(player: ArgPlayer, value: Int, ctx: Game) -> Result<EffectOutput, GameError> {
        
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
