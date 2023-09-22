//
//  Attributes+Extension.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 04/09/2023.
//

extension Attributes {
    func get(_ key: AttributeKey) -> Int {
        guard let value = self[key] else {
            fatalError("missing attribute for key \(key)")
        }

        return value
    }
}
