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
    public struct State: Equatable {
        public let minPlayersCount = 2
        public let maxPlayersCount = 7
        public let speedOptions: [SpeedOption] = SpeedOption.all
        public let playersCount: Int
        public let speedIndex: Int
        public let simulation: Bool
        public let preferredFigure: String?

        public struct SpeedOption: Equatable {
            let label: String
            let value: Int

            static let all: [Self] = [
                .init(label: "Normal", value: 500),
                .init(label: "Fast", value: 0)
            ]
        }
    }

    public enum Action {
        case didTapCloseButton
        case didChangePlayersCount(Int)
        case didChangeWaitDelay(Int)
        case didToggleSimulation
        case didTapFigures
    }

    @StateObject private var store: Store<State, Action>

    public init(store: @escaping () -> Store<State, Action>) {
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
                withAnimation {
                    store.dispatch(.didTapCloseButton)
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
                    set: { store.dispatch(.didChangePlayersCount($0)) }
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
                        store.dispatch(.didChangeWaitDelay(option.value))
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
        Button(action: {
            store.dispatch(.didTapFigures)
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
    SettingsView {
        .init(initial: .mockedData)
    }
}

private extension SettingsView.State {
    static var mockedData: Self {
        .init(
            playersCount: 5,
            speedIndex: 0,
            simulation: false,
            preferredFigure: "Figure1"
        )
    }
}
