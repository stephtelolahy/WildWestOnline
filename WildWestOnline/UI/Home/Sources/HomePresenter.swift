//
//  HomePresenter.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
import Redux
import AppCore

public extension HomeView {
    static let presenter: Presenter<AppState, State> = { _ in
            .init()
    }
}


