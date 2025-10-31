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

        case .navigation(.push(.game)):
            let pauseFunc = dependencies.pause
            Task {
                await pauseFunc(.musicLoneRider)
            }

        case .navigation(.pop):
            let resumeFunc = dependencies.resume
            Task {
                await resumeFunc(.musicLoneRider)
            }

        case .settings(.updateMusicVolume(let value)):
            let setMusicVolumeFunc = dependencies.setMusicVolume
            Task {
                await setMusicVolumeFunc(value)
            }

        default:
            break
        }

        return .none
    }
}
