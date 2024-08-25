//
//  Dictionary+Subscript.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 04/09/2023.
//

extension Dictionary {
    /// Getting non-optional value for given Key
    func get(_ key: Key) -> Value {
        guard let value = self[key] else {
            fatalError("missing value for key \(key)")
        }

        return value
    }
}

extension Dictionary where Value == [String] {
    @available(*, deprecated, renamed: "get", message: "replace with get")
    public func getOrEmpty(_ key: Key) -> Value {
        self[key] ?? []
    }

    func isEmpty(_ key: Key) -> Bool {
        (self[key] ?? []).isEmpty
    }
}
