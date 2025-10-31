//
//  AudioPlayer.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/10/2025.
//

public struct AudioPlayer {
    public var load: ([Sound]) async -> Void
    public var loop: (Sound) async -> Void
    public var play: (Sound) async -> Void
    public var pause: (Sound) async -> Void
    public var resume: (Sound) async -> Void
    public var stop: (Sound) async -> Void
    public var setMusicVolume: (Float) async -> Void
    public var getMusicVolume: () async -> Float

    public init(
        load: @escaping ([Sound]) async -> Void = { _ in },
        loop: @escaping (Sound) async -> Void = { _ in },
        play: @escaping (Sound) async -> Void = { _ in },
        pause: @escaping (Sound) async -> Void = { _ in },
        resume: @escaping (Sound) async -> Void = { _ in },
        stop: @escaping (Sound) async -> Void = { _ in },
        setMusicVolume: @escaping (Float) async -> Void = { _ in },
        getMusicVolume: @escaping () async -> Float = { 1.0 },
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
