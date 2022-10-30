//
//  Select.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

/// select an option during effect resolution
public struct Select: Move, Equatable {
    let value: String?
    public let actor: String
    
    @EquatableNoop
    public var effects: [Effect]
    
    @EquatableNoop
    public var ctx: [String: Any]
    
    public init(value: String?, actor: String, effects: [Effect] = [], ctx: [String: Any] = [:]) {
        self.value = value
        self.actor = actor
        self.effects = effects
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        .success(EffectOutput(state: state, effects: effects))
    }
}
