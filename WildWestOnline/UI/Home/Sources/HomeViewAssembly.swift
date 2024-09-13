//
//  HomeViewAssembly.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//

import SwiftUI
import AppCore
import NavigationCore
import Redux

public enum HomeViewAssembly {
    public static func buildHomeView(_ store: Store<AppState, Any>) -> some View {
        HomeView {
            store.projection(using: HomeViewConnector())
        }
    }
}
