//
//  MainView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import Redux

public struct AppView: View {

    @EnvironmentObject private var store: Store<AppState>

    public init() {}

    public var body: some View {
        Group {
            switch store.state.screens.last {
            case .home:
                HomeView()

            case .game:
                GamePlayView()

            default:
                SplashView()
            }
        }
        .foregroundColor(.primary)
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(previewStore)
    }
}

let previewStore = Store<AppState>(
    initial: AppState(screens: [.splash]),
    reducer: { state, _ in state },
    middlewares: []
)
#endif