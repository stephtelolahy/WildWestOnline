//
//  AudioPlayerKey.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 17/10/2025.
//

import SwiftUI

public extension EnvironmentValues {
    @Entry var audioPlayer: AudioPlayer = .init(
        load: { _ in },
        loop: { _ in },
        play: { _ in },
        pause: { _ in },
        resume: { _ in },
        stop: { _ in },
        setMusicVolume: { _ in },
        getMusicVolume: { 1.0 }
    )
}
