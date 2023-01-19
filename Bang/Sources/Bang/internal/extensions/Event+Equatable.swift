//
//  Effect+Equatable.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

extension Event {
    func isEqualTo(_ other: Event) -> Bool {
        guard let equatableSelf = self as? (any Equatable),
              let equatableOther = other as? (any Equatable) else {
            return false
        }
        
        return equatableSelf.isEqualCastedTo(equatableOther)
    }
}

private extension Equatable {
    func isEqualCastedTo(_ other: any Equatable) -> Bool {
        guard let castedOther = other as? Self else {
            return false
        }
        
        return castedOther == self
    }
}
