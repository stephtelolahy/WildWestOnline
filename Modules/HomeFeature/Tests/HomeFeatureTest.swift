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

enum HomeFeatureTest {
    @MainActor
    @Suite("Initialization")
    struct Initialization {
        @Test func initializeValues() async throws {
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

            await sut.dispatch(.didAppear)

            #expect(soundLoaded)
        }
    }

    @MainActor
    @Suite("Navigation")
    struct Navigation {
        @Test func play() async throws {
            let sut = Store(
                initialState: HomeFeature.State(),
                reducer: HomeFeature.reducer
            )

            let received = await sut.receive(.didTapPlay)

            #expect(received == [.delegate(.play)])
        }

        @Test func settings() async throws {
            let sut = Store(
                initialState: HomeFeature.State(),
                reducer: HomeFeature.reducer
            )

            let received = await sut.receive(.didTapSettings)

            #expect(received == [.delegate(.settings)])
        }
    }
}
