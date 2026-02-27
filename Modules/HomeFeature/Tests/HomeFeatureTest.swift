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

            // When
            let received = await sut.receive(.didTapPlay)

            // Then
            #expect(received == [.delegate(.play)])
        }

        @Test func settings() async throws {
            // Given
            let sut = Store(
                initialState: HomeFeature.State(),
                reducer: HomeFeature.reducer
            )

            // When
            let received = await sut.receive(.didTapSettings)

            // Then
            #expect(received == [.delegate(.settings)])
        }
    }

}
