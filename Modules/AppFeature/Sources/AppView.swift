//
//  AppView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//

import SwiftUI
import Redux
import SettingsFeature
import GameSessionFeature
import HomeFeature

public struct AppView: View {
    public typealias ViewStore = Store<AppFeature.State, AppFeature.Action>

    @StateObject private var store: ViewStore
    @State private var path: [AppFeature.State.Destination] = []
    @State private var isSettingsPresented: Bool = false

    @Environment(\.theme) private var theme

    public init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationStack(path: $path) {
            HomeView {
                store.projection(
                    state: \.home,
                    action: { .home($0) }
                )
            }
            .navigationDestination(for: AppFeature.State.Destination.self) {
                viewForDestination($0)
            }
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsView {
                store.projection(
                    state: \.settings,
                    action: { .settings($0) }
                )
            }
        }
        // Fix Error `Update NavigationAuthority bound path tried to update multiple times per frame`
        .onReceive(store.$state) { state in
            let newPath = state.path
            if newPath != path {
                path = newPath
            }

            let newIsSettingsPresented = state.isSettingsPresented
            if newIsSettingsPresented != isSettingsPresented {
                isSettingsPresented = newIsSettingsPresented
            }
        }
        .onChange(of: path) { _, newPath in
            if newPath != store.state.path {
                Task {
                    await store.dispatch(.setPath(newPath))
                }
            }
        }
        .onChange(of: isSettingsPresented) { _, newIsSettingsPresented in
            if newIsSettingsPresented != store.state.isSettingsPresented {
                Task {
                    await store.dispatch(.setSettingsPresented(newIsSettingsPresented))
                }
            }
        }
        .onReceive(store.dispatchedAction) { event in
            print(event)
        }
        .accentColor(theme.colorAccent)
    }

    @ViewBuilder private func viewForDestination(_ destination: AppFeature.State.Destination) -> some View {
        switch destination {
        case .gameSession:
            GameSessionView {
                store.projection(
                    state: \.gameSession,
                    action: { .gameSession($0) }
                )
            }
        }
    }
}

#Preview {
    AppView {
        .init(
            initialState: .init()
        )
    }
}
