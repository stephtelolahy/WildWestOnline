//
//  AppNavigationFeatureTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/07/2024.
//
import Testing
import NavigationFeature
import Redux

struct AppNavigationFeatureTests {
    private typealias NavigationStore = Store<AppNavigationFeature.State, AppNavigationFeature.Action>

    private func createNavigationStore(initialState: AppNavigationFeature.State) async -> NavigationStore {
        await .init(
            initialState: initialState,
            reducer: AppNavigationFeature.reducer,
            dependencies: .init()
        )
    }

    @Test func showingSettings_shouldDisplaySettings() async throws {
        // Given
        let state = AppNavigationFeature.State()
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = AppNavigationFeature.Action.presentSettingsSheet
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.settingsSheet == .init())
    }

    @Test func showingSettingsFigures_shouldDisplayFigures() async throws {
        // Given
        let state = AppNavigationFeature.State(settingsSheet: .init())
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = AppNavigationFeature.Action.settingsSheet(.push(.figures))
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.settingsSheet == .init(path: [.figures]))
    }

    @Test func closingSettings_shouldRemoveSettings() async throws {
        // Given
        let state = AppNavigationFeature.State(settingsSheet: .init(path: [.figures]))
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = AppNavigationFeature.Action.dismissSettingsSheet
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.settingsSheet == nil)
    }
}
