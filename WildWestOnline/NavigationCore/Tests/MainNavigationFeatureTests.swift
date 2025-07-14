//
//  MainNavigationFeatureTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/07/2024.
//
import Testing
import NavigationCore
import Redux

struct MainNavigationFeatureTests {
    private typealias NavigationStore = Store<MainNavigationFeature.State, Void>

    @MainActor private func createNavigationStore(initialState: MainNavigationFeature.State) -> NavigationStore {
        .init(
            initialState: initialState,
            reducer: MainNavigationFeature.reduce,
            dependencies: ()
        )
    }

    @Test func showingSettings_shouldDisplaySettings() async throws {
        // Given
        let state = MainNavigationFeature.State()
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = MainNavigationFeature.Action.presentSettingsSheet
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.settingsSheet == .init())
    }

    @Test func showingSettingsFigures_shouldDisplayFigures() async throws {
        // Given
        let state = MainNavigationFeature.State(settingsSheet: .init())
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = SettingsNavigationFeature.Action.push(.figures)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.settingsSheet == .init(path: [.figures]))
    }

    @Test func closingSettings_shouldRemoveSettings() async throws {
        // Given
        let state = MainNavigationFeature.State(settingsSheet: .init(path: [.figures]))
        let sut = await createNavigationStore(initialState: state)

        // When
        let action = MainNavigationFeature.Action.dismissSettingsSheet
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.settingsSheet == nil)
    }
}
