//
//  Card+Extensions.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

public extension Card {
    
    /// Copy a card setting unique identifier
    func withId(_ id: String) -> Card {
        var copy = self
        copy.id = id
        return copy
    }
}
