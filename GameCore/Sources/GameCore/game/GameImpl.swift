//
//  GameImpl.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

public struct GameImpl: Game {
    public var players: [String: Player]
    public var playOrder: [String]
    public var turn: String?
    public var deck: [Card]
    public var discard: [Card]
    public var store: [Card]
    public var isOver: Bool
    public var played: [String]
    public var event: Result<Event, Error>?
    
    public init(players: [String: Player] = [:],
                playOrder: [String] = [],
                turn: String? = nil,
                deck: [Card] = [],
                discard: [Card] = [],
                store: [Card] = [],
                isOver: Bool = false,
                played: [String] = [],
                event: Result<Event, Error>? = nil) {
        self.players = players
        self.playOrder = playOrder
        self.turn = turn
        self.deck = deck
        self.discard = discard
        self.store = store
        self.isOver = isOver
        self.played = played
        self.event = event
    }
    
    public func player(_ id: String) -> Player {
        guard let playerObject = players[id] else {
            fatalError(InternalError.missingPlayer(id))
        }
        
        return playerObject
    }
}
