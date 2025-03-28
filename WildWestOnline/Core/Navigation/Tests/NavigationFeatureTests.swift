//
//  NavigationFeatureTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/07/2024.
//
import Testing
import NavigationCore
import Redux

struct NavigationFeatureTests {
    private typealias NavigationStore = Store<NavigationFeature.State, Void>

    @MainActor private func createNavigationStore(initialState: NavigationFeature.State) -> NavigationStore {
        .init(
            initialState: initialState,
            reducer: NavigationFeature.reduce,
            dependencies: ()
        )
    }

    @Test func app_whenCompletedSplash_shouldSetHomeScreen() async throws {
        // Given
        let state = NavigationFeature.State()
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = NavStackFeature<NavigationFeature.State.MainDestination>.Action.push(.home)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.mainStack.path == [.home])
    }

    @Test func showingSettings_shouldDisplaySettings() async throws {
        // Given
        let state = NavigationFeature.State(mainStack: .init(path: [.home]))
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = NavStackFeature<NavigationFeature.State.MainDestination>.Action.present(.settings)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.mainStack.sheet == .settings)
    }

    @Test func closingSettings_shouldRemoveSettings() async throws {
        // Given
        let state = NavigationFeature.State(mainStack: .init(path: [.home], sheet: .settings))
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = NavStackFeature<NavigationFeature.State.MainDestination>.Action.dismiss
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.mainStack.sheet == nil)
    }
}
