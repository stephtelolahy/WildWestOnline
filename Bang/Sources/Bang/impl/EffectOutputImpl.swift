//
//  EffectOutputImpl.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

public struct EffectOutputImpl: EffectOutput {
    public var state: Game?
    public var effects: [Effect]?
    public var options: [Effect]?
    
    public init(state: Game? = nil, effects: [Effect]? = nil, options: [Effect]? = nil) {
        self.state = state
        self.effects = effects
        self.options = options
    }
}
