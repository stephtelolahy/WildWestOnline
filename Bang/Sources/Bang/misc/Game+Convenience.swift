//
//  Game+Convenience.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

public extension Game {
    
    func player(_ id: String) -> Player {
        guard let playerObject = players[id] else {
            fatalError("player not found")
        }
        
        return playerObject
    }
}

extension Game {
    
    func actor() -> String {
        guard let actorId = data[.actor] as? String else {
            fatalError("missing actor")
        }
        
        return actorId
    }
}
