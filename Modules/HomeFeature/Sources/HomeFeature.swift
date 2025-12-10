//
//  HomeFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 04/12/2025.
//

import Redux
import AudioClient
import UserDefaultsClient

public enum HomeFeature {
    public struct State: Equatable, Sendable {
        var isFirstLoad: Bool = true

        public init() {}
    }

    public enum Action {
        // View
        case didAppear
        case didDisappear
        case didTapPlay
        case didTapSettings

        // Delegate
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
        case .didAppear:
            if state.isFirstLoad {
                state.isFirstLoad = false
                return .run {
                    await dependencies.audioClient.setMusicVolume(dependencies.userDefaultsClient.musicVolume())
                    await dependencies.audioClient.load(AudioClient.Sound.allSfx)
                    await dependencies.audioClient.play(.musicLoneRider)
                    return .none
                }
            } else {
                return .run {
                    await dependencies.audioClient.resume(AudioClient.Sound.musicLoneRider)
                    return .none
                }
            }

        case .didDisappear:
            return .run {
                await dependencies.audioClient.pause(AudioClient.Sound.musicLoneRider)
                return .none
            }

        case .didTapPlay:
            return .run {
                .delegate(.play)
            }

        case .didTapSettings:
            return .run {
                .delegate(.settings)
            }

        case .delegate:
            return .none
        }
    }
}
