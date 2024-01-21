//
//  SettingsView.swift
//
//
//  Created by Hugues Telolahy on 08/12/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import Navigation
import Redux
import SwiftUI
import Utils

public struct SettingsView: View {
    @StateObject private var store: Store<SettingsState>
    @State private var speedIndex = 1
    private var speedOptions = ["Slow", "Normal", "Fast"]

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
                        store.dispatch(NavAction.dismiss)
                    }
                }
            }
        }
    }

    private var preferencesSection: some View {
        Section(header: Text("PREFRENCES")) {
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

            HStack {
                Image(systemName: "record.circle")
                Toggle(isOn: Binding<Bool>(
                    get: { store.state.simulation },
                    set: { _ in store.dispatch(SettingsAction.toggleSimulation) }
                ).animation()) {
                    Text("Simulation")
                }
            }

            HStack {
                Image(systemName: "hare")
                Picker(selection: $speedIndex, label: Text("Game speed")) {
                    ForEach(0..<(speedOptions.count), id: \.self) {
                        Text(speedOptions[$0])
                    }
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
                simulation: false
            ),
            reducer: SettingsState.reducer
        )
    }
}
