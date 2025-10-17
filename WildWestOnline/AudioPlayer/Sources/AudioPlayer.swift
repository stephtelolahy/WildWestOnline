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
    public var setGlobalVolume: (Float) async -> Void
    public var setVolume: (Sound, Float) async -> Void
    public var stop: (Sound) async -> Void

    public typealias Sound = String
}
