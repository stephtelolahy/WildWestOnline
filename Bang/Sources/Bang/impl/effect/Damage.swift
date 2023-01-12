//
//  Damage.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// Deals damage to a character, attempting to reduce its Health by the stated amount
public struct Damage: Effect, Equatable {
    @EquatableCast private var player: ArgPlayer
    private let value: Int
    
    public init(player: ArgPlayer, value: Int) {
        self.player = player
        self.value = value
    }

    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        fatalError()
    }
}
