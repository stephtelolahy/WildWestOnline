//
//  Choose.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// select an option during effect resolution
public class Choose: Effect, Equatable {
    
    private let actor: String
    private let value: String?
    private let effects: [Effect]
    
    public init(actor: String, value: String?, effects: [Effect]) {
        self.actor = actor
        self.value = value
        self.effects = effects
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        /// emit state changes even if no changes occurred
        /// to mark that effect was successfully resolved
        .success(EffectOutputImpl(state: ctx, effects: effects))
    }
    
    public static func == (lhs: Choose, rhs: Choose) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
    
}
