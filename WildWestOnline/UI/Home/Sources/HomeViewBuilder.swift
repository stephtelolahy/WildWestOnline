//
//  HomeViewBuilder.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/09/2024.
//

import SwiftUI
import Redux
import AppCore

public struct HomeViewBuilder: View {
    @EnvironmentObject private var store: Store<AppState>

    public init() {}

    public var body: some View {
        HomeView {
            store.projection(HomeView.presenter)
        }
    }
}

extension HomeView {
    static let presenter: Presenter<AppState, State> = { _ in
            .init()
    }
}
