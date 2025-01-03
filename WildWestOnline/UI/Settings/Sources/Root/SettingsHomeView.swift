//
//  SettingsHomeView.swift
//
//
//  Created by Hugues Telolahy on 08/12/2023.
//

import Redux
import SwiftUI
import NavigationCore
import SettingsCore

struct SettingsHomeView: View {
    struct State: Equatable {
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

    @StateObject private var store: Store<State>

    init(store: @escaping () -> Store<State>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        Form {
            preferencesSection
        }
        .navigationTitle("Settings")
        .toolbar {
            Button("Done") {
                withAnimation {
                    store.dispatch(NavigationStackAction<MainDestination>.dismiss)
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
                    set: { store.dispatch(SettingsAction.updatePlayersCount($0)) }
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
                        store.dispatch(SettingsAction.updateActionDelayMilliSeconds(option.value))
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
                set: { _ in store.dispatch(SettingsAction.toggleSimulation) }
            ).animation()) {
                Text("Simulation")
            }
        }
    }

    private var figureView: some View {
        Button(action: {
            store.dispatch(NavigationStackAction<SettingsDestination>.push(.figures))
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
    SettingsHomeView {
        .init(initial: .mockedData)
    }
}

private extension SettingsHomeView.State {
    static var mockedData: Self {
        .init(
            playersCount: 5,
            speedIndex: 0,
            simulation: false,
            preferredFigure: "Figure1"
        )
    }
}
