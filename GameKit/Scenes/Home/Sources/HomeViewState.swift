// swiftlint:disable:this file_name
//
//  HomeViewState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import AppCore
import Redux

public extension HomeView {
    struct State: Equatable {
    }
}

public extension HomeView.State {
    static func from(globalState: AppState) -> Self? {
        .init()
    }
}
