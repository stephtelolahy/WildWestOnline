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
                cardsSection
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
                in: 2...16
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
                        store.state.speedIndex
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

    // MARK: - Cards

    struct CardUsage {
        let name: String
        let count: Int
    }

    @State private var cardsUsage: [CardUsage] = [
        .init(name: "beer", count: 95),
        .init(name: "jail", count: 80),
        .init(name: "missed", count: 85)
    ]

    private var cardsSection: some View {
        Section(header: Text("CARDS")) {
            ForEach(cardsUsage, id: \.name) { card in
                HStack {
                    Text(card.name)
                    Spacer()
                    Text(String(card.count))
                        .foregroundStyle(.secondary)
                }
            }
        }
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
