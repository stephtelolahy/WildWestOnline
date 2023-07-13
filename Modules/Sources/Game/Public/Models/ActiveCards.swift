//
//  ActiveCards.swift
//  
//
//  Created by Hugues Telolahy on 05/06/2023.
//

public struct ActiveCards: Codable, Equatable {
    public let player: String
    public let cards: [String]

    public init(player: String, cards: [String]) {
        self.player = player
        self.cards = cards
    }
}
