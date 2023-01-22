//
//  Arg.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

/// Number argument
public protocol ArgNumber {
    
    func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<Int, Error>
}

/// Player argument
public protocol ArgPlayer {
    
    func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<ArgOutput, Error>
}

/// Card argument
public protocol ArgCard {
    
    /// Resolving card argument
    /// - Parameters:
    ///   - ctx: game state
    ///   - eventCtx: play context
    ///   - chooser: player making choice
    ///   - owner: player owning the card if any
    func resolve(_ ctx: Game, eventCtx: EventContext, chooser: String, owner: String?) -> Result<ArgOutput, Error>
}

/// Resolved argument
public enum ArgOutput {
    
    /// Create similar child effects with well known objects identifiers
    case identified([String])
    
    /// Create choice effects with well known objects identifiers
    case selectable([ArgOption])
}

/// Selectable argument option
public protocol ArgOption {
    
    /// arg identifier
    var value: String { get }
    
    /// displayed arg label
    var label: String { get }
}
