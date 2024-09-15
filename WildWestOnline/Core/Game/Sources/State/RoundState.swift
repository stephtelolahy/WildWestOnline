//
//  RoundState.swift
//  
//
//  Created by Hugues Telolahy on 05/07/2024.
//

public struct RoundState: Codable, Equatable {
    /// Initial order
    public let startOrder: [String]

    /// Playing order
    public var playOrder: [String]

    /// Current turn's player
    public var turn: String?
}
