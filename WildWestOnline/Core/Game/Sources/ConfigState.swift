//
//  ConfigState.swift
//  
//
//  Created by Hugues Telolahy on 11/07/2024.
//

public struct ConfigState: Codable, Equatable {
    /// Wait delay between two visible actions
    public let waitDelayMilliseconds: Int

    /// Play mode by player
    public let playMode: [String: PlayMode]
}
