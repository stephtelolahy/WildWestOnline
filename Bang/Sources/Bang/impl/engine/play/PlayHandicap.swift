//
//  PlayHandicap.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

struct PlayHandicap: Move {
    let actor: String
    let card: String
    let target: String?

    func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        fatalError(.unexpected)
    }
    
    func isValid(_ ctx: Game) -> Result<Void, GameError> {
        .failure(.unknown)
    }
}
