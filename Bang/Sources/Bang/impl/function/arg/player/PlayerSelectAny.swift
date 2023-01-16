//
//  PlayerSelectAny.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// any other player
public struct PlayerSelectAny: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<ArgResolved, GameError> {
        let others = ctx.playOrder.filter { $0 != playCtx.actor }
        return .success(.selectable(others.toOptions()))
    }
}
