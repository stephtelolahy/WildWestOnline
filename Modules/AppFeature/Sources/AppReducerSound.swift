//
//  GameReducerSound.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//
import Redux
import AudioClient

extension AppFeature {
    static func reducerSound(
        into state: inout State,
        action: Action,
        dependencies: AudioClient
    ) -> Effect<Action> {
        switch action {
        case .game(let gameAction):
            let soundMatcher = SoundMatcher(specialSounds: state.cardLibrary.specialSounds)
            if let sfx = soundMatcher.sfx(on: gameAction) {
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
