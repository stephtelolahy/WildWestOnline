//
//  FiguresViewState.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 08/09/2024.
//
import AppCore
import SettingsCore

public extension FiguresView {
    struct State: Equatable {
        public let figures: [Figure]

        public struct Figure: Equatable {
            let name: String
            let isFavorite: Bool
        }
    }

    enum Action {
        case didChangePreferredFigure(String)
    }

    static let deriveState: (AppState) -> State? = { state in
            .init(
                figures: state.inventory.figures.map {
                    .init(
                        name: $0,
                        isFavorite: $0 == state.settings.preferredFigure
                    )
                }
            )
    }

    static let embedAction: (Action, AppState) -> Any = { action, _ in
        switch action {
        case .didChangePreferredFigure(let figure):
            SettingsAction.updatePreferredFigure(figure)
        }
    }
}
