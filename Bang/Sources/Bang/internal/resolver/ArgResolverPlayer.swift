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
                
            case let .selectable(items):
                let options = items.map { Choose(actor: ctx.actor, label: $0.label, effects: [copy($0.value)]) }
                return .success(EffectOutputImpl(options: options))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
}

extension ArgResolverPlayer {
    
    static func resolve(_ player: ArgPlayer, ctx: Game) -> Result<ArgResolved, GameError> {
        switch player {
        case let .select(distance):
            switch distance {
            case .any:
                return resolveSelectAny(ctx: ctx)
                
            case let .at(range):
                return resolveSelectPlayerAt(range, ctx: ctx)
                
            default:
                fatalError("unimplemented resolver for select distance \(distance)")
            }
            
        case .actor:
            return resolveActor(ctx: ctx)
            
        case .all:
            return resolveAll(ctx: ctx)
            
        case .damaged:
            return resolveDamaged(ctx: ctx)
            
        case .next:
            return resolveNext(ctx: ctx)
            
        default:
            fatalError("unimplemented resolver for player \(player)")
        }
    }
    
    static func resolveActor(ctx: Game) -> Result<ArgResolved, GameError> {
        .success(.identified([ctx.actor]))
    }
    
    static func resolveAll(ctx: Game) -> Result<ArgResolved, GameError> {
        let players = ctx.playOrder
            .starting(with: ctx.actor)
        return .success(.identified(players))
    }
    
    static func resolveDamaged(ctx: Game) -> Result<ArgResolved, GameError> {
        let damaged = ctx.playOrder
            .starting(with: ctx.actor)
            .filter { ctx.player($0).health < ctx.player($0).maxHealth }
        
        guard !damaged.isEmpty else {
            return .failure(.noPlayerDamaged)
        }
        
        return .success(.identified(damaged))
    }
    
    static func resolveNext(ctx: Game) -> Result<ArgResolved, GameError> {
        guard let turn = ctx.turn else {
            fatalError(.missingTurn)
        }
        
        let next = ctx.playOrder
            .element(after: turn)
        return .success(.identified([next]))
    }
    
    static func resolveSelectAny(ctx: Game) -> Result<ArgResolved, GameError> {
        let others = ctx.playOrder.filter { $0 != ctx.actor }
        return .success(.selectable(others.toOptions()))
    }
    
    static func resolveSelectPlayerAt(_ range: Int, ctx: Game) -> Result<ArgResolved, GameError> {
        let players = ctx.playersAtRange(range, from: ctx.actor)
        guard !players.isEmpty else {
            return .failure(.noPlayersAtRange(range))
        }
        
        return .success(.selectable(players.toOptions()))
    }
}
