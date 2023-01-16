//
//  Repeat.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Repeat an effect
public struct Repeat: Effect, Equatable {
    @EquatableCast private var times: ArgNumber
    @EquatableCast private var effect: Effect
    
    public init(times: ArgNumber, effect: Effect) {
        self.times = times
        self.effect = effect
    }
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<EffectOutput, GameError> {
        switch times.resolve(ctx, playCtx: playCtx) {
        case let .failure(error):
            return .failure(error)
            
        case let .success(number):
            guard number > 0 else {
                return .success(EffectOutputImpl())
            }
            
            let children: [EffectNode] = (0..<number).map { _ in effect.withCtx(playCtx) }
            
            return .success(EffectOutputImpl(effects: children))
        }
    }
}
