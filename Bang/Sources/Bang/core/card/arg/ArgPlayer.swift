//
//  ArgPlayer.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Player argument
public protocol ArgPlayer {
    
    func resolve(_ ctx: Game) -> Result<ArgResolved, GameError>
}
