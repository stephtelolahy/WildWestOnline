//
//  Dictionary+Subscript.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 04/09/2023.
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

extension Dictionary where Value == [String] {
    func isEmpty(_ key: Key) -> Bool {
        get(key).isEmpty
    }
}
