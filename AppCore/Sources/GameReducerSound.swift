//
//  GameReducerSound.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//
import Redux
import GameCore
import AudioPlayer

extension GameFeature {
    static func reducerSound(
        into state: inout State,
        action: Action,
        dependencies: AudioPlayer
    ) -> Effect<Action> {
        if let sfx = SoundMatcher().sfx(on: action) {
            let playFunc = dependencies.play
            Task {
                await playFunc(sfx)
            }
        }
        return .none
    }
}
