//
//  Array+Attribute.swift
//  
//
//  Created by Hugues Telolahy on 03/03/2023.
//

public extension Array where Element == any Attribute {

    func getValue<T: Attribute>(for type: T.Type) -> T.Value? {
        guard let attribute = first(where: { $0 is T }) else {
            return nil
        }

        return (attribute as? T)?.value
    }

    mutating func setValue<T: Attribute>(_ attr: T) {
        removeAll(where: { $0 is T })
        append(attr)
    }

    mutating func removeValue<T: Attribute>(for type: T.Type) {
        removeAll(where: { $0 is T })
    }
}