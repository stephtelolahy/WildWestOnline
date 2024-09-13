//
//  FiguresViewConnector.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 08/09/2024.
//
import AppCore
import SettingsCore
import Redux

struct FiguresViewConnector: Connector {
    func deriveState(_ state: AppState) -> FiguresView.State? {
        .init(
            figures: state.inventory.figures.map {
                .init(
                    name: $0,
                    isFavorite: $0 == state.settings.preferredFigure
                )
            }
        )
    }

    func embedAction(_ action: FiguresView.Action) -> Any {
        switch action {
        case .didChangePreferredFigure(let figure):
            SettingsAction.updatePreferredFigure(figure)
        }
    }
}
