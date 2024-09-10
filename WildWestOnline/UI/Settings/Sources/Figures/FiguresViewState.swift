//
//  FiguresViewState.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 08/09/2024.
//
import AppCore
import SettingsCore
import Redux

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

    struct Connector: Redux.Connector {
        public init() {}

        public func deriveState(_ state: AppState) -> State? {
            .init(
                figures: state.inventory.figures.map {
                    .init(
                        name: $0,
                        isFavorite: $0 == state.settings.preferredFigure
                    )
                }
            )
        }

        public func embedAction(_ action: Action, _ state: AppState) -> Any {
            switch action {
            case .didChangePreferredFigure(let figure):
                SettingsAction.updatePreferredFigure(figure)
            }
        }
    }
}
