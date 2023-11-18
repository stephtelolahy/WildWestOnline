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
                .foregroundColor(.accentColor)
                .onAppear {

                    DispatchQueue.main.asyncAfter(deadline: .now() + splashDelaySeconds) {
                        store.dispatch(AppAction.showScreen(.home))
                    }
                }
            VStack(spacing: 8) {
                Spacer()
                Text("Stéphano Telolahy").font(.subheadline).foregroundColor(.primary)
                Text("stephano.telolahy@gmail.com").font(.subheadline).foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

#if DEBUG
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .environmentObject(previewStore)
    }
}
#endif
