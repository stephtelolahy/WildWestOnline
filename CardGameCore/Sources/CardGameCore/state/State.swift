//
//  State.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

/// Stores the information of the game state of all players.
public struct State {
    
    // MARK: - Renderable objects
    
    /// all players by player identifier
    public var players: [String: Player] = [:]
    
    /// active players, playing order
    public var playOrder: [String] = []
    
    /// current player
    public var turn: String?
    
    /// current turn's phase
    public var phase: Int
    
    /// played cards during current turn
    public var turnPlayed: [String] = []
    
    /// deck
    public var deck: [Card]
    
    /// discard pile
    public var discard: [Card]
    
    /// choosable zone
    public var store: [Card] = []
    
    /// is Game over
    public var isGameOver = false
    
    // MARK: - Effect resolution objects
    
    /// played cards sequences, last played card is on the top
    public var sequences: [Sequence] = []
    
    /// selected arguments during effect resolution
    public var selectedArgs: [String: String] = [:]
    
    /// pending action by player
    public var decisions: [String: [Move]] = [:]
    
    // MARK: - Init
    
    public init(
        players: [String: Player] = [:],
        playOrder: [String] = [],
        turn: String? = nil,
        phase: Int = 1,
        deck: [Card] = [],
        discard: [Card] = [],
        sequences: [Sequence] = [],
        decisions: [String: [Move]] = [:],
        isGameOver: Bool = false
    ) {
        self.players = players
        self.playOrder = playOrder
        self.turn = turn
        self.phase = phase
        self.deck = deck
        self.discard = discard
        self.sequences = sequences
        self.decisions = decisions
        self.isGameOver = isGameOver
    }
}
