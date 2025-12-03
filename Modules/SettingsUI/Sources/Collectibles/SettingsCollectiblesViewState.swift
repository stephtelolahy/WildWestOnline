//
//  SettingsFiguresViewState.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/10/2025.
//
import Redux
import AppFeature

extension SettingsCollectiblesView {
    struct ViewState: Equatable {
        let cards: [Card]

        struct Card: Equatable {
            let name: String
            let description: String?
        }
    }

    typealias ViewStore = Store<ViewState, AppFeature.Action>
}

extension SettingsCollectiblesView.ViewState {
    init?(appState: AppFeature.State) {
        cards = appState.cardLibrary.cards.filter { $0.type == .collectible }
            .map {
                .init(
                    name: $0.name,
                    description: $0.description
                )
            }
    }
}
