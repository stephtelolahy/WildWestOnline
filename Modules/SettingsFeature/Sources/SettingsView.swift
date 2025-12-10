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

    public init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationStack(path: store.binding(\.path, send: { .setPath($0) })) {
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
