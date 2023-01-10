//
//  EffectResolverMain.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

public struct EffectResolverMain: EffectResolver {
    
    public init() {}
    
    public func resolve(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError> {
        resolver(for: effect).resolve(effect, ctx: ctx)
    }
    
    private func resolver(for effect: Effect) -> EffectResolver {
        switch effect {
        case .heal:
            return EffectResolverHeal()
            
        case .play:
            return EffectResolverPlay(verifier: PlayReqVerifierImpl(), mainResolver: self)
            
        case .dummy:
            return EffectResolverDummy()
            
        case .emitError:
            return EffectResolverEmitError()
            
        default:
            fatalError("Undefined resolver for \(self)")
        }
    }
}
