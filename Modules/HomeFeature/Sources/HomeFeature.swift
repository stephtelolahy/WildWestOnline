//
//  HomeFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 04/12/2025.
//

import Redux
import AudioClient
import PreferencesClient

public enum HomeFeature {
    public struct State: Equatable, Sendable {
        var isFirstLoad: Bool = true

        public init() {}
    }

    public enum Action {
        case onAppear
        case onDisappear

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
        case .onAppear:
            if state.isFirstLoad {
                state.isFirstLoad = false
                return .run {
                    await dependencies.audioClient.setMusicVolume(dependencies.preferencesClient.musicVolume())
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

        case .onDisappear:
            return .run {
                await dependencies.audioClient.pause(AudioClient.Sound.musicLoneRider)
                return .none
            }

        case .delegate:
            return .none
        }
    }
}
