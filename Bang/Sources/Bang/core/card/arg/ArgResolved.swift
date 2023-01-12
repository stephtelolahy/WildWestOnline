//
//  ArgResolved.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

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
