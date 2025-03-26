//
//  NavigationCoreTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/07/2024.
//
import Testing
import NavigationCore
import Redux

struct NavigationCoreTests {
    @Test func app_whenCompletedSplash_shouldSetHomeScreen() async throws {
        // Given
        let state = NavigationState()
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = NavigationStackAction<MainDestination>.push(.home)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.mainStack.path == [.home])
    }

    @Test func showingSettings_shouldDisplaySettings() async throws {
        // Given
        let state = NavigationState(mainStack: .init(path: [.home]))
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = NavigationStackAction<MainDestination>.present(.settings)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.mainStack.sheet == .settings)
    }

    @Test func closingSettings_shouldRemoveSettings() async throws {
        // Given
        let state = NavigationState(mainStack: .init(path: [.home], sheet: .settings))
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = NavigationStackAction<MainDestination>.dismiss
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.mainStack.sheet == nil)
    }
}

private typealias NavigationStore = Store<NavigationState, Void>

@MainActor private func createNavigationStore(initialState: NavigationState) -> NavigationStore {
    .init(
        initialState: initialState,
        reducer: navigationReducer,
        dependencies: ()
    )
}
