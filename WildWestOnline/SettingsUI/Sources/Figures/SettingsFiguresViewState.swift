//
//  SettingsFiguresViewState.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/10/2025.
//
import Redux
import AppCore

extension SettingsFiguresView {
    struct ViewState: Equatable {
        let figures: [Figure]

        struct Figure: Equatable {
            let name: String
            let isFavorite: Bool
        }
    }

    typealias ViewStore = Store<ViewState, AppFeature.Action, Void>
}

extension SettingsFiguresView.ViewState {
    init?(appState: AppFeature.State) {
        figures = appState.inventory.cards.names(for: .character)
            .map {
                .init(
                    name: $0,
                    isFavorite: $0 == appState.settings.preferredFigure
                )
            }
    }
}
