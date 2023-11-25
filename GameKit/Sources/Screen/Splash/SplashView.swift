//
//  SplashView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers

import Redux
import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var store: Store<AppState>
    private let splashDelaySeconds = 2.0

    var body: some View {
        ZStack {
            Text("CREATIVE GAMES")
                .font(.headline)
                .foregroundStyle(.primary)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + splashDelaySeconds) {
                        store.dispatch(AppAction.showScreen(.home))
                    }
                }
            VStack(spacing: 8) {
                Spacer()
                Text("Stéphano Telolahy")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Text("stephano.telolahy@gmail.com")
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
