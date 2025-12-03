//
//  SettingsFiguresViewState.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/10/2025.
//
import Redux
import AppFeature

extension SettingsFiguresView {
    struct ViewState: Equatable {
        let figures: [Figure]

        struct Figure: Equatable {
            let name: String
            let description: String?
            let isFavorite: Bool
        }
    }

    typealias ViewStore = Store<ViewState, AppFeature.Action>
}

extension SettingsFiguresView.ViewState {
    init?(appState: AppFeature.State) {
        figures = appState.cardLibrary.cards.filter { $0.type == .figure }
            .map {
                .init(
                    name: $0.name,
                    description: $0.description,
                    isFavorite: $0.name == appState.settings.preferredFigure
                )
            }
    }
}
