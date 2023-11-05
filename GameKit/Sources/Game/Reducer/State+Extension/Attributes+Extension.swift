// swiftlint:disable:this file_name
//
//  Attributes+Extension.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 04/09/2023.
//

extension Dictionary where Key == AttributeKey, Value == Int {
    func get(_ key: AttributeKey) -> Int {
        guard let value = self[key] else {
            fatalError("missing attribute \(key)")
        }

        return value
    }
}
