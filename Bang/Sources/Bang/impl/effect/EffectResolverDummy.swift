//
//  EffectResolverDummy.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

struct EffectResolverDummy: EffectResolver {

    func resolve(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError> {
        .success(EffectOutputImpl())
    }
}
