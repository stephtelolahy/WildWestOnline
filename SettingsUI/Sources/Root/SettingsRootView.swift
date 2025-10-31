//
//  SettingsRootView.swift
//
//
//  Created by Hugues Telolahy on 08/12/2023.
//

import SwiftUI

struct SettingsRootView: View {
    @StateObject private var store: ViewStore

    @Environment(\.dismiss) private var dismiss

    init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        Form {
            preferencesSection
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Settings")
        .toolbar {
            if #available(iOS 26.0, macOS 26.0, *) {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
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
            volumeView
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
                            await store.dispatch(.settings(.updatePlayersCount(index)))
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
                            await store.dispatch(.settings(.updateActionDelayMilliSeconds(option.value)))
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
                        await store.dispatch(.settings(.toggleSimulation))
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
                await store.dispatch(.navigation(.settingsSheet(.push(.figures))))
            }
        }, label: {
            HStack {
                Image(systemName: "lanyardcard")
                Text("Preferred figure")
                Spacer()
                Text(store.state.preferredFigure ?? "")
            }
            .foregroundStyle(.foreground)
        })
    }

    private var volumeView: some View {
        HStack {
            Image(systemName: "speaker.wave.2")
            VStack(alignment: .leading) {
                Text("Sound volume")
                Slider(
                    value: Binding<Float>(
                        get: { store.state.musicVolume },
                        set: { newValue in
                            Task {
                                await store.dispatch(.settings(.updateMusicVolume(newValue)))
                            }
                        }
                    ),
                    in: 0.0...1.0
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsRootView {
            .init(initialState: .mock, dependencies: ())
        }
    }
}

private extension SettingsRootView.ViewState {
    static var mock: Self {
        .init(
            playersCount: 5,
            speedIndex: 0,
            simulation: false,
            preferredFigure: "Figure1",
            musicVolume: 1.0
        )
    }
}
