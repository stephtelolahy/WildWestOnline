//
//  SettingsHomeView.swift
//
//
//  Created by Hugues Telolahy on 08/12/2023.
//

import SwiftUI
import Redux

struct SettingsHomeView: View {
    typealias ViewStore = Store<SettingsHomeFeature.State, SettingsHomeFeature.Action>

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
            cardsLibrarySection
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
        .task {
            await store.dispatch(.didAppear)
        }
    }

    // MARK: - Preferences

    private var preferencesSection: some View {
        Section(header: Text("PREFRENCES")) {
            playersCountView
            speedView
            simulationView
            volumeView
        }
    }

    private var playersCountView: some View {
        HStack {
            Image(systemName: "person.2")
            Stepper(
                "Players count: \(store.state.playersCount)",
                value: store.binding(\.playersCount, send: { .didUpdatePlayersCount($0) })
                    .animation(),
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
                        store.state.speedOptions.firstIndex { $0.value == store.state.actionDelayMilliSeconds } ?? 0
                    },
                    set: { index in
                        Task {
                            await store.dispatch(.didUpdateActionDelayMilliSeconds(store.state.speedOptions[index].value))
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
            Toggle(isOn: store.binding(\.simulation, send: { _ in .didToggleSimulation })
                .animation()) {
                Text("Simulation")
            }
        }
    }

    private var volumeView: some View {
        HStack {
            Image(systemName: "speaker.wave.2")
            VStack(alignment: .leading) {
                Text("Sound volume")
                Slider(
                    value: store.binding(\.musicVolume, send: { .didUpdateMusicVolume($0) }),
                    in: 0.0...1.0
                )
            }
        }
    }

    // MARK: - CardLibrary

    private var cardsLibrarySection: some View {
        Section(header: Text("LIBRARY")) {
            figuresView
            collectiblesView
        }
    }

    private var figuresView: some View {
        Button(action: {
            Task {
                await store.dispatch(.didTapFigures)
            }
        }, label: {
            HStack {
                Image(systemName: "face.smiling")
                Text("Figures")
                Spacer()
                Text(store.state.preferredFigure ?? "")
            }
            .foregroundStyle(.foreground)
        })
    }

    private var collectiblesView: some View {
        Button(action: {
            Task {
                await store.dispatch(.didTapCollectibles)
            }
        }, label: {
            HStack {
                Image(systemName: "moonphase.new.moon.inverse")
                Text("Collectibles")
            }
            .foregroundStyle(.foreground)
        })
    }
}

#Preview {
    NavigationStack {
        SettingsHomeView {
            .init(
                initialState: .init(
                    playersCount: 5,
                    actionDelayMilliSeconds: 0,
                    simulation: false,
                    preferredFigure: "Figure1",
                    musicVolume: 1.0
                )
            )
        }
    }
}
