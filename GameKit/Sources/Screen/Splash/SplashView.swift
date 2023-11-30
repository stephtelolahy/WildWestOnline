//
//  SplashView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers prefixed_toplevel_constant

import Redux
import Routing
import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var store: Store<AppState>
    private let splashDelaySeconds = 2.0

    var body: some View {
        ZStack {
            Text("splash.editor.name", bundle: .module)
                .font(.headline)
                .foregroundStyle(.primary)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + splashDelaySeconds) {
                        store.dispatch(AppAction.showScreen(.home))
                    }
                }
            VStack(spacing: 8) {
                Spacer()
                Text("splash.developer.name", bundle: .module)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Text("splash.developer.email", bundle: .module)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(previewStore)
}

private let previewStore = Store<AppState>(initial: AppState(screens: [.splash]))
