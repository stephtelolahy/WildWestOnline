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
        // swiftlint:disable force_unwrapping
        assert(options == nil || !options!.isEmpty, "options should not be empty")
        assert(effects == nil || !effects!.isEmpty, " children should not be empty")
        
        self.state = state
        self.effects = effects
        self.options = options
    }
}
