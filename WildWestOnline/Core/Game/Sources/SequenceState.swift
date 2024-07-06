//
//  SequenceState.swift
//  
//
//  Created by Hugues Telolahy on 06/07/2024.
//

public struct SequenceState: Codable, Equatable {
    /// Queued effects
    public var queue: [GameAction]

    /// Pending action by player
    public var chooseOne: [String: ChooseOne]

    /// Playable cards by player
    public var active: [String: [String]]

    /// Play counter by card
    public var played: [String: Int]
}
