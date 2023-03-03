//
//  Array+Attribute.swift
//  
//
//  Created by Hugues Telolahy on 03/03/2023.
//

import GameDSL

extension Array where Element == Attribute {

    func getValue<T: Attribute>(for type: T.Type) -> T? {
        guard let attribute = first(where: { $0 is T }) else {
            return nil
        }

        return attribute as? T
    }
}
