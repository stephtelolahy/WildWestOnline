//
//  EffectResolverApply.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

struct EffectResolverApply: EffectResolver {
    let resolverPlayer: ArgResolverPlayer
    
    func resolve(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .apply(player, child) = effect else {
            fatalError("unexpected effect type \(effect)")
        }
        
        guard case let .id(playerId) = player else {
            return resolverPlayer.resolve(player, ctx: ctx) {
                .apply(player: .id($0), effect: child)
            }
        }
        
        fatalError("unimplemented")
    }
}
