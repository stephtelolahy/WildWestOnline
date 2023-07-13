//
//  EffectContext+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 20/05/2023.
//

extension EffectContext {
    func get(_ key: ContextKey) -> String {
        guard let value = self[key] else {
            fatalError("missing value for key \(key)")
        }

        return value
    }

    func copy(_ other: Self) -> Self {
        self.merging(other) { _, new in new }
    }
}
