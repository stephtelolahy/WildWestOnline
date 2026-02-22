//
//  HomeFeatureTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 04/12/2025.
//

import Testing
import Redux
@testable import HomeFeature
import Combine

struct HomeFeatureTest {
    @MainActor
    @Suite("Initialization")
    struct Initialization {
        @Test func initializeValues() async throws {
            // Given
            var soundLoaded = false
            let sut = Store(
                initialState: HomeFeature.State(),
                reducer: HomeFeature.reducer,
                withDependencies: {
                    $0.audioClient.load = { _ in
                        soundLoaded = true
                    }
                }
            )

            // When
            await sut.dispatch(.didAppear)

            // Then
            #expect(soundLoaded)
        }
    }

    @MainActor
    @Suite("Navigation")
    struct Navigation {
        @Test func play() async throws {
            // Given
            let sut = Store(
                initialState: HomeFeature.State(),
                reducer: HomeFeature.reducer
            )

            var dispatchedActions: [HomeFeature.Action] = []
            var cancellables: Set<AnyCancellable> = []
            sut.dispatchedAction.sink {
                dispatchedActions.append($0)
            }
            .store(in: &cancellables)

            // When
            await sut.dispatch(.didTapPlay)

            // Then
            #expect(dispatchedActions.last == .delegate(.play))
        }

        @Test func settings() async throws {
            // Given
            let sut = Store(
                initialState: HomeFeature.State(),
                reducer: HomeFeature.reducer
            )

            var dispatchedActions: [HomeFeature.Action] = []
            var cancellables: Set<AnyCancellable> = []
            sut.dispatchedAction.sink {
                dispatchedActions.append($0)
            }
            .store(in: &cancellables)

            // When
            await sut.dispatch(.didTapSettings)

            // Then
            #expect(dispatchedActions.last == .delegate(.settings))
        }
    }

}
