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
    @StateObject private var store: Store<State, Action>

    public init(store: @escaping () -> Store<State, Action>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationView {
            Form {
                preferencesSection
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") {
                    withAnimation {
                        store.dispatch(.didTapCloseButton)
                    }
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
                    set: { store.dispatch(.didSelectPlayersCount($0)) }
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
                        let option = store.state.speedOptions[index]
                        store.dispatch(.didSelectWaitDelayMilliseconds(option.value))
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
                set: { _ in store.dispatch(.didToggleSimulation) }
            ).animation()) {
                Text("Simulation")
            }
        }
    }

    private var figureView: some View {
        HStack {
            Image(systemName: "star")
            Picker(
                selection: Binding<Int>(
                    get: {
                        store.state.preferredFigureIndex
                    },
                    set: { index in
                        let figure = store.state.figureOptions[index]
                        store.dispatch(.didSelectFigure(figure))
                    }
                ),
                label: Text(
                    "Preferred figure"
                )
            ) {
                ForEach(0..<(store.state.figureOptions.count), id: \.self) {
                    Text(store.state.figureOptions[$0])
                }
            }
        }
    }
}

#Preview {
    SettingsView {
        Store(initial: .sample)
    }
}

private extension SettingsView.State {
    static var sample: Self {
        .init(
            playersCount: 5,
            speedIndex: 0,
            simulation: false,
            figureOptions: ["Figure1", "Figure2", "Figure3"],
            preferredFigureIndex: -1
        )
    }
}
