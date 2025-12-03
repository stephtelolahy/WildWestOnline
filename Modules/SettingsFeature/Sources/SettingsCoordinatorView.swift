//
//  SettingsCoordinatorView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
import Redux
import SwiftUI

public struct SettingsCoordinatorView: View {
    typealias ViewStore = Store<SettingsCoordinatorFeature.State, SettingsCoordinatorFeature.Action>

    @StateObject private var store: ViewStore

    init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    @State private var path: [SettingsCoordinatorFeature.State.Destination] = []

    public var body: some View {
        NavigationStack(path: $path) {
            SettingsHomeView {
                store.projection(
                    state: \.home,
                    action: { .home($0) }
                )
            }
            .navigationDestination(for: SettingsCoordinatorFeature.State.Destination.self) {
                viewForDestination($0)
            }
        }
        // Fix Error `Update NavigationAuthority bound path tried to update multiple times per frame`
        .onReceive(store.$state) { state in
            let newPath = state.path
            guard newPath != path else {
                return
            }

            path = newPath
        }
        .onChange(of: path) { _, newPath in
            guard newPath != store.state.path else {
                return
            }

            Task {
                await store.dispatch(.setPath(newPath))
            }
        }
        .presentationDetents([.large])
    }

    @ViewBuilder private func viewForDestination(_ destination: SettingsCoordinatorFeature.State.Destination) -> some View {
        switch destination {
        case .figures:
            SettingsFiguresView {
                store.projection(
                    state: \.figures,
                    action: { .figures($0) }
                )
            }

        case .collectibles:
            SettingsCollectiblesView {
                store.projection(
                    state: \.collectibles,
                    action: { .collectibles($0) }
                )
            }
        }
    }
}

#Preview {
    SettingsCoordinatorView {
        .init(
            initialState: .init(
                home: .init(
                    playersCount: 5,
                    actionDelayMilliSeconds: 0,
                    simulation: false,
                    preferredFigure: nil,
                    musicVolume: 0
                ),
                figures: .init(
                    figures: []
                ),
                collectibles: .init(
                    cards: []
                ),
                path: []
            )
        )
    }
}
