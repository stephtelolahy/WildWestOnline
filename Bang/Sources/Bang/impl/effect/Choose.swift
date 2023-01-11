//
//  Choose.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// select an option during effect resolution
public struct Choose: Effect, Equatable {
    private let actor: String
    private let label: String
    
    @EquatableNoop
    var effects: [Effect]
    
    public init(actor: String, label: String, effects: [Effect] = []) {
        self.actor = actor
        self.label = label
        self.effects = effects
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        /// emit state changes even if no changes occurred
        /// to mark that effect was successfully resolved
        .success(EffectOutputImpl(state: ctx, effects: effects))
    }
}
