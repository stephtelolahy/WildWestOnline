//
//  Arg.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

/// Number argument
public protocol ArgNumber {
    
    func resolve(_ ctx: Game) -> Result<Int, GameError>
}

/// Player argument
public protocol ArgPlayer {
    
    func resolve(_ ctx: Game) -> Result<ArgResolved, GameError>
}

/// Card argument
public protocol ArgCard {
    
    /// Resolving card argument
    /// - Parameters:
    ///   - ctx: game state
    ///   - chooser: player making choice
    ///   - owner: player owning the card if any
    func resolve(_ ctx: Game, chooser: String, owner: String?) -> Result<ArgResolved, GameError>
}

/// Resolved argument
public enum ArgResolved {
    
    /// Create similar child effects with well known objects identifiers
    case identified([String])
    
    /// Create choice effects with well known objects identifiers
    case selectable([Option])
}

public extension ArgResolved {
    struct Option {
        let value: String
        let label: String
    }
}
