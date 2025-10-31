//
//  GameReducerSound.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//
import Redux
import AudioPlayer

extension AppFeature {
    static func reducerSound(
        into state: inout State,
        action: Action,
        dependencies: AudioPlayer
    ) -> Effect<Action> {
        switch action {
        case .game(let gameAction):
            if let sfx = SoundMatcher().sfx(on: gameAction) {
                let playFunc = dependencies.play
                Task {
                    await playFunc(sfx)
                }
            }

        default:
            break
        }

        return .none
    }
}
