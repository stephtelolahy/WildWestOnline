//
//  HomeView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers prefixed_toplevel_constant

import Redux
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: Store<AppState>

    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Image(systemName: "gamecontroller")
                .font(.system(size: 100))
            Button(String(localized: "menu.start.button", bundle: .module)) {
                withAnimation {
                    store.dispatch(AppAction.showScreen(.game))
                }
            }
            .font(.headline)
            .padding()
            .foregroundStyle(.primary)
            .background(Color.accentColor)
            .clipShape(.rect(cornerRadius: 40))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView()
        .environmentObject(previewStore)
        .environment(\.locale, .init(identifier: "fr"))
}

private let previewStore = Store<AppState>(
    initial: AppState(screens: [.home(.init())]),
    reducer: { state, _ in state },
    middlewares: []
)
