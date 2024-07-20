//
//  ConfigState.swift
//  
//
//  Created by Hugues Telolahy on 11/07/2024.
//

public struct ConfigState: Codable, Equatable {
    /// Wait delay between two visible actions
    public var waitDelayMilliseconds: Int

    /// Play mode by player
    public var playMode: [String: PlayMode]
}

public enum PlayMode: Equatable, Codable {
    /// Player is controller by user
    case manual

    /// Player is controlled by AI agent
    case auto
}
