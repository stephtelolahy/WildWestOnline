//
//  SettingsView.swift
//
//
//  Created by Hugues Telolahy on 08/12/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import Redux
import SwiftUI

public struct SettingsView: View {
    @StateObject private var store: Store<SettingsState>

    public init(store: @escaping () -> Store<SettingsState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view, so
        // later changes to the view's name input have no effect.
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
                        store.dispatch(SettingsAction.close)
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
                in: Self.minPlayersCount...Self.maxPlayersCount
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
                        speedIndex
                    },
                    set: { index in
                        let option = SpeedOption.all[index]
                        let action = SettingsAction.updateWaitDelayMilliseconds(option.value)
                        store.dispatch(action)
                    }
                ),
                label: Text(
                    "Game speed"
                )
            ) {
                ForEach(0..<(SpeedOption.all.count), id: \.self) {
                    Text(SpeedOption.all[$0].label)
                }
            }
        }
    }

    private var speedIndex: Int {
        SpeedOption.all.firstIndex { $0.value == store.state.waitDelayMilliseconds } ?? 0
    }
}

#Preview {
    SettingsView {
        Store<SettingsState>(
            initial: .init(
                playersCount: 5,
                waitDelayMilliseconds: 0,
                simulation: false
            ),
            reducer: SettingsState.reducer
        )
    }
}

// MARK: - Constants

extension SettingsView {
    struct SpeedOption {
        let label: String
        let value: Int

        static let defaultWaitDelay = 500

        static let all: [Self] = [
            .init(label: "Normal", value: defaultWaitDelay),
            .init(label: "Fast", value: 0)
        ]
    }

    static let minPlayersCount = 2
    static let maxPlayersCount = 16
}