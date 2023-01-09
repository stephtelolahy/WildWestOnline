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
        case .heal:
            return resolveHeal(effect, ctx: ctx)
            
        default:
            fatalError("unimplemented resolver for \(effect)")
        }
    }
}

private extension EffectResolverImpl {
    
    func resolveHeal(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .heal(player, value) = effect else {
            fatalError("unexpected effect type \(effect)")
        }
        
        guard var playerObj = ctx.players[player] else {
            fatalError("player not found \(player)")
        }
        
        guard playerObj.health < playerObj.maxHealth else {
            return .failure(.playerAlreadyMaxHealth(player))
        }
        
        let newHealth = min(playerObj.health + value, playerObj.maxHealth)
        playerObj.health = newHealth
        
        var state = ctx
        state.players[player] = playerObj
        
        return .success(EffectOutputImpl(state: state))
    }
}
