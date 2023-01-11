//
//  Apply.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Apply an effect to a group of players
public struct Apply: Effect, Equatable {
    
    private let player: ArgPlayer
    
    @EquatableNoop
    private var effect: Effect
    
    public init(player: ArgPlayer, effect: Effect) {
        self.player = player
        self.effect = effect
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        fatalError("unimplemented")
    }
}
