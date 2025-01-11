//
//  SettingsFiguresContainerView.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/09/2024.
//

import SwiftUI
import Redux
import AppCore

public struct SettingsFiguresContainerView: View {
    @EnvironmentObject private var store: Store<AppState, AppDependencies>

    public init() {}

    public var body: some View {
        SettingsFiguresView {
            store.projection(SettingsFiguresView.presenter)
        }
    }
}

extension SettingsFiguresView {
    static let presenter: Presenter<AppState, State> = { state in
            .init(
                figures: state.inventory.figures.map {
                    .init(
                        name: $0,
                        isFavorite: $0 == state.settings.preferredFigure
                    )
                }
            )
    }
}
