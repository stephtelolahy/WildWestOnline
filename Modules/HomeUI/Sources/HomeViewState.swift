//
//  HomeViewState.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/10/2025.
//

import Foundation
import AppFeature
import Redux

public extension HomeView {
    struct ViewState: Equatable {}

    typealias ViewStore = Store<ViewState, AppFeature.Action>
}

public extension HomeView.ViewState {
    init?(appState: AppFeature.State) { }
}
