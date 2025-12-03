//
//  AudioClientKey.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//

import Redux

public extension Dependencies {
    var audioClient: AudioClient {
        get { self[AudioClientKey.self] }
        set { self[AudioClientKey.self] = newValue }
    }
}

private enum AudioClientKey: DependencyKey {
    nonisolated(unsafe) static let defaultValue: AudioClient = .noop
}

private extension AudioClient {
    static var noop: Self {
        .init(
            load: { _ in },
            loop: { _ in },
            play: { _ in },
            pause: { _ in },
            resume: { _ in },
            stop: { _ in },
            setMusicVolume: { _ in },
            getMusicVolume: { 0.0 }
        )
    }
}
