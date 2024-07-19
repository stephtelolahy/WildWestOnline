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

extension Dictionary where Value == [String] {
    func getOrEmpty(_ key: Key) -> Value {
        self[key] ?? []
    }

    func isEmpty(_ key: Key) -> Bool {
        (self[key] ?? []).isEmpty
    }
}
