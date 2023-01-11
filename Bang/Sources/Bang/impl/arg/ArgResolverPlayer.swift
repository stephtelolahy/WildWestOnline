//
//  ArgResolverPlayer.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

enum ArgResolverPlayer {
    
    static func resolve(_ player: ArgPlayer, ctx: Game, copy: @escaping (String) -> Effect) -> Result<EffectOutput, GameError> {
        switch resolve(player, ctx: ctx) {
        case let .success(data):
            switch data {
            case let .identified(pIds):
                let children = pIds.map { copy($0) }
                return .success(EffectOutputImpl(effects: children))
                
            case let .selectable(cIds):
                let options = cIds.map { Choose(actor: ctx.actor, value: $0, effects: [copy($0)]) }
                return .success(EffectOutputImpl(options: options))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    static func resolve(_ player: ArgPlayer, ctx: Game) -> Result<ArgResolved, GameError> {
        switch player {
            
        case .actor:
            return .success(.identified([ctx.actor]))
            
        case .all:
            return .success(.identified(ctx.playOrder.starting(with: ctx.actor)))
            
        case .damaged:
            let damaged = ctx.playOrder.starting(with: ctx.actor)
                .filter { ctx.player($0).health < ctx.player($0).maxHealth }
            
            guard !damaged.isEmpty else {
                return .failure(.noPlayerDamaged)
            }
            
            return .success(.identified(damaged))
            
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
