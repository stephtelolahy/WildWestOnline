//
//  SettingsFiguresPresenter.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux
import AppCore

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
