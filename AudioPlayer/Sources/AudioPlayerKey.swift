//
//  AudioPlayerKey.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 17/10/2025.
//

public extension AudioPlayer {
    @available(*, deprecated, message: "Use middleware")
    @MainActor static let shared: Self = .live()
}
