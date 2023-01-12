//
//  ArgNumber.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Number argument
public protocol ArgNumber {
    
    func resolve(_ ctx: Game) -> Result<Int, GameError>
}
