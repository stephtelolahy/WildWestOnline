//
//  CardImpl+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 16/01/2023.
//

public extension Card {
    
    func withId(_ id: String) -> Card {
        var copy = self
        copy.id = id
        return copy
    }
    
    func withValue(_ value: String) -> Card {
        var copy = self
        copy.value = value
        return copy
    }
}
