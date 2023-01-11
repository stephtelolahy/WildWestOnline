//
//  ArgResolverPlayer.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

enum ArgResolverPlayer {
    
    static func resolve(_ player: ArgPlayer, ctx: Game, copy: @escaping (String) -> Effect) -> Result<EffectOutput, GameError> {
        switch player {
            
        // TODO: handle choice first, then identify the rest
            
        case .actor:
            let children = [copy(ctx.actor)]
            return .success(EffectOutputImpl(effects: children))
            
        case .damaged:
            let damaged = ctx.playOrder.starting(with: ctx.actor)
                .filter { ctx.player($0).health < ctx.player($0).maxHealth }
            
            guard !damaged.isEmpty else {
                return .failure(.noPlayerDamaged)
            }
            
            let children = damaged.map { copy($0) }
            return .success(EffectOutputImpl(effects: children))
            
        default:
            fatalError("unimplemented resolver for player \(player)")
        }
    }
}

private extension Game {
    
    var actor: String {
        guard let actorId = data[.actor] as? String else {
            fatalError(.missingActor)
        }
        
        return actorId
    }
}
