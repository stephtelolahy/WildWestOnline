//
//  Choose.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Move
/// select an option during effect resolution
public struct Choose: Effect, Equatable {
    private let player: String
    private let label: String
    @EquatableIgnore var children: [EffectNode]
    
    public init(player: String, label: String, children: [EffectNode] = []) {
        self.player = player
        self.label = label
        self.children = children
    }
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<EffectOutput, GameError> {
        /// emit state changes even if no changes occurred
        /// to mark that effect was successfully resolved
        .success(EffectOutputImpl(state: ctx, effects: children))
    }
}

public enum Label {
    /// Random hand card label
    /// displayed when choosing random hand card
    public static let randomHand = "randomHand"
    
    /// Choose to pass when asked to do an action
    public static let pass = "pass"
}
