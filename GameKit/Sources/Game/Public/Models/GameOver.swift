//
//  GameOver.swift
//  
//
//  Created by Hugues Telolahy on 06/05/2023.
//

public struct GameOver: Codable, Equatable {

    public let winner: String

    public init(winner: String) {
        self.winner = winner
    }
}
