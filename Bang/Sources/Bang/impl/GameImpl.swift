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
    public var decisions: [Effect]
    public var queue: [Effect]
    public var event: Result<Effect, GameError>?
    public var data: [ContextKey: Any]
    
    public init(players: [String: Player] = [:],
                playOrder: [String] = [],
                turn: String? = nil,
                deck: [Card] = [],
                discard: [Card] = [],
                store: [Card] = [],
                isOver: Bool = false,
                played: [String] = [],
                decisions: [Effect] = [],
                queue: [Effect] = [],
                event: Result<Effect, GameError>? = nil,
                data: [ContextKey: Any] = [:]) {
        self.players = players
        self.playOrder = playOrder
        self.turn = turn
        self.deck = deck
        self.discard = discard
        self.store = store
        self.isOver = isOver
        self.played = played
        self.decisions = decisions
        self.queue = queue
        self.event = event
        self.data = data
    }
}
