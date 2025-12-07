//
//  HomeFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 04/12/2025.
//

import Redux

public enum HomeFeature {
    public struct State: Equatable, Sendable {
        public init() {}
    }

    public enum Action {
        case playTapped
        case settingsTapped

        case delegate(Delegate)

        public enum Delegate {
            case play
            case settings
        }
    }

    public static func reducer(
        state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .playTapped:
            return .run { .delegate(.play) }

        case .settingsTapped:
            return .run { .delegate(.settings) }

        case .delegate:
            return .none
        }
    }
}

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
