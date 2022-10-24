//
//  Dictionary+Extension.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 24/10/2022.
//

public extension Dictionary where Key == EffectKey, Value == any Equatable {
    
    func stringForKey(_ key: Key) -> String? {
        self[key] as? String
    }
}
