//
//  ForceDiscard.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// Player must discard a specific card. If cannot, then apply some effects
public struct ForceDiscard: Effect, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableCast private var card: ArgCard
    @EquatableIgnore private var otherwise: Effect
    
    public init(player: ArgPlayer, card: ArgCard, otherwise: Effect) {
        self.player = player
        self.card = card
        self.otherwise = otherwise
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        fatalError()
    }
}
