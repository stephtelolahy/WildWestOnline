//
//  Event+Equatable.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
import ExtensionsKit

public extension Event {
    func isEqualTo(_ other: Event) -> Bool {
        guard let equatableSelf = self as? (any Equatable),
              let equatableOther = other as? (any Equatable) else {
            return false
        }
        
        return equatableSelf.isEqualToEquatable(equatableOther)
    }
}