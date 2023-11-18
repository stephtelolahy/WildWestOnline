//
//  Attributes+Extension.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 04/09/2023.
//

extension Dictionary where Key == String, Value == Int {
    func get(_ key: String) -> Int {
        guard let value = self[key] else {
            fatalError("missing attribute \(key)")
        }

        return value
    }
}
