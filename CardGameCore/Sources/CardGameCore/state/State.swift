//
//  State.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

/// Stores all the information of the game
/// containing renderable objects and occurred events
public struct State {
    
    /// all players by player identifier
    public var players: [String: Player] = [:]
    
    /// active players, playing order
    public var playOrder: [String] = []
    
    /// current player
    public var turn: String?
    
    /// current turn's phase
    public var phase: Int
    
    /// played cards during current turn
    public var played: [String] = []
    
    /// deck
    public var deck: [Card]
    
    /// discard pile
    public var discard: [Card]
    
    /// choosable zone
    public var store: [Card] = []
    
    /// is Game over
    public var isOver = false
    
    /// pending actions
    /// among which one must be choosen to proceed effect resolving
    public var decisions: [Move] = []
    
    /// last occurred event
    public var event: Event?
    
    // MARK: - Init
    
    public init(
        players: [String: Player] = [:],
        playOrder: [String] = [],
        turn: String? = nil,
        phase: Int = 1,
        played: [String] = [],
        deck: [Card] = [],
        discard: [Card] = [],
        decisions: [Move] = [],
        isOver: Bool = false
    ) {
        self.players = players
        self.playOrder = playOrder
        self.turn = turn
        self.phase = phase
        self.played = played
        self.deck = deck
        self.discard = discard
        self.decisions = decisions
        self.isOver = isOver
    }
}
