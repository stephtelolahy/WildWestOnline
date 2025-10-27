//
//  AudioPlayerKey.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 17/10/2025.
//

public extension AudioPlayer {
    @MainActor static let shared: AudioPlayer = .live(bundles: [.module])
}
