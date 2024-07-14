//
//  Dictionary+Subscript.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 04/09/2023.
//

extension Dictionary {
    func get(_ key: Key) -> Value {
        guard let value = self[key] else {
            fatalError("missing attribute \(key)")
        }

        return value
    }
}
