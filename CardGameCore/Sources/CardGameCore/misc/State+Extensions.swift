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
    
    /// Get `non-null` `PlaySequence` with given card
    func sequence(_ cardRef: String) -> Sequence {
        guard let result = sequences[cardRef] else {
            fatalError(.sequenceNotFound(cardRef))
        }
        return result
    }
    
    /// Get `Decision` waiting a given action
    func decision<T: Equatable>(waiting move: T) -> Decision? {
        decisions.first { $0.value.options.contains { $0 as? T == move } }?.value
    }
}
