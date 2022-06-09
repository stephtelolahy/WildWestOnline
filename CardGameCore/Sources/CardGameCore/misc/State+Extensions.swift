//
//  State+Extension.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

public extension State {
    
    /// Get `non-null` `Player` with given identifier
    func player(_ id: String) -> Player {
        guard let result = players[id] else {
            fatalError(.playerNotFound(id))
        }
        return result
    }
    
    /// Check if waiting a given action
    func isWaiting<T: Equatable>(_ move: T) -> Bool {
        decisions.contains { $0.value.contains { $0 as? T == move } }
    }
}
