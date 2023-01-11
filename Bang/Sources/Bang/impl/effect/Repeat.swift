//
//  Repeat.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Repeat an effect
public struct Repeat: Effect, Equatable {
    private let times: ArgNumber
    
    @EquatableNoop
    private var effect: Effect
    
    public init(times: ArgNumber, effect: Effect) {
        self.times = times
        self.effect = effect
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        let number: Int
        if case let .exact(value) = times {
            number = value
        } else {
            number = ArgResolverNumber.resolve(times, ctx: ctx)
        }
        
        guard number > 0 else {
            return .success(EffectOutputImpl())
        }
        
        let children: [Effect] = (0..<number).map { _ in effect }
        return .success(EffectOutputImpl(effects: children))

    }
}
