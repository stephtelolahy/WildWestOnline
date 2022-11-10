//
//  Dictionary+Extension.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 24/10/2022.
//

public extension Dictionary where Key == String {
    
    func stringForKey(_ key: Key) -> String? {
        self[key] as? String
    }
    
    func booleanForKey(_ key: Key) -> Bool? {
        self[key] as? Bool
    }
    
    var actor: String {
        guard let actor = stringForKey(.CTX_ACTOR) else {
            fatalError(.missingActor)
        }
        return actor
    }
}
