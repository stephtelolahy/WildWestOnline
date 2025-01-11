//
//  HomeContainerView.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/09/2024.
//

import SwiftUI
import Redux
import AppCore

public struct HomeContainerView: View {
    @EnvironmentObject private var store: Store<AppState, AppDependencies>

    public init() {}

    public var body: some View {
        HomeView {
            store.projection(deriveState: HomeView.presenter)
        }
    }
}

extension HomeView {
    static let presenter: Presenter<AppState, State> = { _ in
            .init()
    }
}
