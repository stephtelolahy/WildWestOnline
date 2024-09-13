//
//  SplashViewAssembly.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//

import SwiftUI
import AppCore
import NavigationCore
import Redux

public enum SplashViewAssembly {
    public static func buildSplashView(_ store: Store<AppState, Any>) -> some View {
        SplashView {
            store.projection(using: SplashViewConnector())
        }
    }
}
