//
//  SettingsView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
import Redux
import SwiftUI

public struct SettingsView: View {
    public typealias ViewStore = Store<SettingsFeature.State, SettingsFeature.Action>

    @StateObject private var store: ViewStore
    @State private var path: [SettingsFeature.State.Destination] = []

    public init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationStack(path: $path) {
            SettingsHomeView {
                store.projection(state: \.home, action: { .home($0) })
            }
#if os(iOS) || os(tvOS) || os(visionOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .navigationDestination(for: SettingsFeature.State.Destination.self) {
                viewForDestination($0)
            }
        }
        .presentationDetents([.large])
        // Fix Error `Update NavigationAuthority bound path tried to update multiple times per frame`
        .onReceive(store.$state) { newValue in
            path = newValue.path
        }
        .onChange(of: path) { _, newValue in
            Task {
                await store.dispatch(.setPath(newValue))
            }
        }
    }

    @ViewBuilder private func viewForDestination(_ destination: SettingsFeature.State.Destination) -> some View {
        switch destination {
        case .figures:
            SettingsFiguresView {
                store.projection(state: \.figures, action: { .figures($0) })
            }

        case .collectibles:
            SettingsCollectiblesView {
                store.projection(state: \.collectibles, action: { .collectibles($0) })
            }
        }
    }
}

#Preview {
    SettingsView {
        .init(
            initialState: .init()
        )
    }
}
