//
//  EffectResolverEmitError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

struct EffectResolverEmitError: EffectResolver {

    func resolve(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .emitError(error) = effect else {
            fatalError("unexpected effect type \(effect)")
        }
        
        return .failure(error)
    }
}
