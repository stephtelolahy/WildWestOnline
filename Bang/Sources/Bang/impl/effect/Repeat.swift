//
//  Repeat.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Repeat an effect
public struct Repeat: Effect {

    private let times: ArgNumber
    private let effect: Effect
    
    public init(times: ArgNumber, effect: Effect) {
        self.times = times
        self.effect = effect
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .exact(number) = times else {
            fatalError("implement times resolving \(times)")
        }
        
        let children: [Effect] = (0..<number).map { _ in effect }
        return .success(EffectOutputImpl(effects: children))

    }
}
