//
//  Equatable+Any.swift
//  
//
//  Created by Hugues Telolahy on 06/03/2023.
//

public extension Equatable {
    func isEqualToEquatable(_ other: any Equatable) -> Bool {
        guard let castedOther = other as? Self else {
            return false
        }

        return castedOther == self
    }
}
