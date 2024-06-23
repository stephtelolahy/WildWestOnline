// swiftlint:disable:this file_name
//
//  HomeViewState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//
import AppCore

public extension HomeView {
    struct State: Equatable {
    }

    static let deriveState: (AppState) -> State? = { _ in
        .init()
    }
}
