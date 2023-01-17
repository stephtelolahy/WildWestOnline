//
//  EffectOutputImpl.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

public struct EffectOutputImpl: EffectOutput {
    public var state: Game?
    public var children: [EffectNode]?
    
    public init(state: Game? = nil, children: [EffectNode]? = nil) {
        // swiftlint:disable force_unwrapping
        assert(children == nil || !children!.isEmpty, " children should not be empty")
        
        self.state = state
        self.children = children
    }
}
