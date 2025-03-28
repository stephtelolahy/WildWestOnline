//
//  SettingsRootView.swift
//
//
//  Created by Hugues Telolahy on 08/12/2023.
//

import Redux
import SwiftUI
import AppCore
import NavigationCore
import SettingsCore

public struct SettingsRootView: View {
    public struct State: Equatable {
        let minPlayersCount = 2
        let maxPlayersCount = 7
        let speedOptions: [SpeedOption] = SpeedOption.all
        let playersCount: Int
        let speedIndex: Int
        let simulation: Bool
        let preferredFigure: String?

        struct SpeedOption: Equatable {
            let label: String
            let value: Int

            static let all: [Self] = [
                .init(label: "Normal", value: 500),
                .init(label: "Fast", value: 0)
            ]
        }
    }

    @StateObject private var store: Store<State, Void>

    public init(store: @escaping () -> Store<State, Void>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        Form {
            preferencesSection
        }
        .navigationTitle("Settings")
        .toolbar {
            Button("Done") {
                Task {
                    await store.dispatch(NavigationCore.NavigationStack<Navigation.State.MainDestination>.Action.dismiss)
                }
            }
        }
    }

    // MARK: - Preferences

    private var preferencesSection: some View {
        Section(header: Text("PREFRENCES")) {
            playersCountView
            speedView
            simulationView
            figureView
        }
    }

    private var playersCountView: some View {
        HStack {
            Image(systemName: "person.2")
            Stepper(
                "Players count: \(store.state.playersCount)",
                value: Binding<Int>(
                    get: { store.state.playersCount },
                    set: { index in
                        Task {
                            await store.dispatch(Settings.Action.updatePlayersCount(index))
                        }

                    }
                ).animation(),
                in: store.state.minPlayersCount...store.state.maxPlayersCount
            )
        }
    }

    private var speedView: some View {
        HStack {
            Image(systemName: "hare")
            Picker(
                selection: Binding<Int>(
                    get: {
                        store.state.speedIndex
                    },
                    set: { index in
                        Task {
                            let option = store.state.speedOptions[index]
                            await store.dispatch(Settings.Action.updateActionDelayMilliSeconds(option.value))
                        }
                    }
                ),
                label: Text(
                    "Game speed"
                )
            ) {
                ForEach(0..<(store.state.speedOptions.count), id: \.self) {
                    Text(store.state.speedOptions[$0].label)
                }
            }
        }
    }

    private var simulationView: some View {
        HStack {
            Image(systemName: "record.circle")
            Toggle(isOn: Binding<Bool>(
                get: { store.state.simulation },
                set: { _ in
                    Task {
                        await store.dispatch(Settings.Action.toggleSimulation)
                    }
                }
            ).animation()) {
                Text("Simulation")
            }
        }
    }

    private var figureView: some View {
        Button(action: {
            Task {
                await store.dispatch(NavigationCore.NavigationStack<Navigation.State.SettingsDestination>.Action.push(.figures))
            }
        }, label: {
            HStack {
                Image(systemName: "lanyardcard.fill")
                Text("Preferred figure")
                Spacer()
                Text(store.state.preferredFigure ?? "")
            }
        })
    }
}

#Preview {
    SettingsRootView {
        .init(initialState: .mock, dependencies: ())
    }
}

private extension SettingsRootView.State {
    static var mock: Self {
        .init(
            playersCount: 5,
            speedIndex: 0,
            simulation: false,
            preferredFigure: "Figure1"
        )
    }
}

public extension SettingsRootView.State {
    init?(appState: AppState) {
        playersCount = appState.settings.playersCount
        speedIndex = SpeedOption.all.firstIndex { $0.value == appState.settings.actionDelayMilliSeconds } ?? 0
        simulation = appState.settings.simulation
        preferredFigure = appState.settings.preferredFigure
    }
}
