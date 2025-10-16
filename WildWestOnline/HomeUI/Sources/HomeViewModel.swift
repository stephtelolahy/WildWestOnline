//
//  HomeViewState.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/10/2025.
//

import Foundation
import AppCore
import Redux

public extension HomeView {
    struct ViewState: Equatable {}

    typealias ViewStore = Store<ViewState, AppFeature.Action, Void>
}

public extension HomeView.ViewState {
    init?(appState: AppFeature.State) { }
}
