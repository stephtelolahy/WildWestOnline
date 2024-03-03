//
//  SettingsView.swift
//
//
//  Created by Hugues Telolahy on 08/12/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import AppCore
import Redux
import SettingsCore
import SwiftUI

public struct SettingsView: View {
    @StateObject private var store: Store<State>

    public init(store: @escaping () -> Store<State>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationView {
            Form {
                preferencesSection
            }
            .toolbar {
                Button("Done") {
                    withAnimation {
                        store.dispatch(AppAction.close)
                    }
                }
            }
        }
    }

    // MARK: - Preferences

    private var preferencesSection: some View {
        Section(header: Text("PREFRENCES")) {
            playersCountView
            simulationView
            speedView
        }
    }

    private var playersCountView: some View {
        HStack {
            Image(systemName: "gamecontroller")
            Stepper(
                "Players count: \(store.state.playersCount)",
                value: Binding<Int>(
                    get: { store.state.playersCount },
                    set: { store.dispatch(SettingsAction.updatePlayersCount($0)) }
                ).animation(),
                in: store.state.minPlayersCount...store.state.maxPlayersCount
            )
        }
    }

    private var simulationView: some View {
        HStack {
            Image(systemName: "record.circle")
            Toggle(isOn: Binding<Bool>(
                get: { store.state.simulation },
                set: { _ in store.dispatch(SettingsAction.toggleSimulation) }
            ).animation()) {
                Text("Simulation")
            }
        }
    }

    private var speedView: some View {
        HStack {
            Image(systemName: "hare")
            Picker(
                selection: Binding<Int>(
                    get: {
                        store.state.currentSpeedIndex
                    },
                    set: { index in
                        let option = store.state.speedOptions[index]
                        let action = SettingsAction.updateWaitDelayMilliseconds(option.value)
                        store.dispatch(action)
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
}

#Preview {
    SettingsView {
        Store<SettingsView.State>(initial: previewState)
    }
}

private var previewState: SettingsView.State {
    .init(
        playersCount: 5,
        maxPlayersCount: 7,
        currentSpeedIndex: 0,
        simulation: false
    )
}
