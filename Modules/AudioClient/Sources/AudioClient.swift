//
//  AudioClient.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/10/2025.
//

public struct AudioClient {
    public var load: ([Sound]) async -> Void
    public var loop: (Sound) async -> Void
    public var play: @Sendable (Sound) async -> Void
    public var pause: @Sendable (Sound) async -> Void
    public var resume: @Sendable (Sound) async -> Void
    public var stop: (Sound) async -> Void
    public var setMusicVolume: @Sendable (Float) async -> Void
    public var getMusicVolume: () async -> Float

    public init(
        load: @escaping ([Sound]) async -> Void,
        loop: @escaping (Sound) async -> Void,
        play: @Sendable @escaping (Sound) async -> Void,
        pause: @Sendable @escaping (Sound) async -> Void,
        resume: @Sendable @escaping (Sound) async -> Void,
        stop: @escaping (Sound) async -> Void,
        setMusicVolume: @Sendable @escaping (Float) async -> Void,
        getMusicVolume: @escaping () async -> Float,
    ) {
        self.load = load
        self.loop = loop
        self.play = play
        self.pause = pause
        self.resume = resume
        self.stop = stop
        self.setMusicVolume = setMusicVolume
        self.getMusicVolume = getMusicVolume
    }

    public typealias Sound = String
}

public extension AudioClient {
    static func empty() -> Self {
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
