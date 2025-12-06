//
//  GameReducerSound.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//
/*
extension AppFeature {
    static func reducerSound(
        into state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .game(let gameAction):
            let soundMatcher = SoundMatcher(specialSounds: dependencies.cardLibrary.specialSounds())
            if let sfx = soundMatcher.sfx(on: gameAction) {
                let playFunc = dependencies.audioClient.play
                Task {
                    await playFunc(sfx)
                }
            }

        case .navigation(.push(.game)):
            let pauseFunc = dependencies.audioClient.pause
            Task {
                await pauseFunc(.musicLoneRider)
            }

        case .navigation(.pop):
            let resumeFunc = dependencies.audioClient.resume
            Task {
                await resumeFunc(.musicLoneRider)
            }

        case .settings(.updateMusicVolume(let value)):
            let setMusicVolumeFunc = dependencies.audioClient.setMusicVolume
            Task {
                await setMusicVolumeFunc(value)
            }

        default:
            break
        }

        return .none
    }
}
*/
