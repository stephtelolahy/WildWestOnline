//
//  ArgResolved.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Rerepsenting resolved argument
enum ArgResolved {
    
    /// Create similar child effects with well known objects identifiers
    case identified([String])
    
    /// Create choice effects with well known objects identifiers
    case selectable([Option])
}

extension ArgResolved {
    
    struct Option {
        let value: String
        let label: String
    }
}

extension Array where Element == String {
    
    func toOptions() -> [ArgResolved.Option] {
        map { ArgResolved.Option(value: $0, label: $0) }
    }
}
