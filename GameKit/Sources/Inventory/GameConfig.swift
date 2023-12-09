//
//  GameConfig.swift
//  
//
//  Created by Hugues Telolahy on 09/12/2023.
//

public struct GameConfig: Codable, Equatable {
    public var playersCount: Int

    public init(playersCount: Int) {
        self.playersCount = playersCount
    }
}
