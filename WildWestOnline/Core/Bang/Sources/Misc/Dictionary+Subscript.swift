//
//  Dictionary+Subscript.swift
//  Bang
//
//  Created by Hugues Telolahy on 27/10/2024.
//

public extension Dictionary {
    /// Getting non-optional value for given Key
    func get(_ key: Key) -> Value {
        guard let value = self[key] else {
            fatalError("missing value for key \(key)")
        }

        return value
    }
}
