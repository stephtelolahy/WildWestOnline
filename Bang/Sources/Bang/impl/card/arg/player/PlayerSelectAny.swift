//
//  PlayerSelectAny.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// any other player
public struct PlayerSelectAny: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<ArgResolved, GameError> {
        let others = ctx.playOrder.filter { $0 != ctx.actor }
        return .success(.selectable(others.toOptions()))
    }
}
