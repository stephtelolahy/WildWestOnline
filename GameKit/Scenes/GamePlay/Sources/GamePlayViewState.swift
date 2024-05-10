// swiftlint:disable:this file_name
//
//  GamePlayViewState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//
// swiftlint:disable nesting

import GameCore

public extension GamePlayView {
    struct State: Equatable {
        public let players: [PlayerItem]
        public let message: String
        public let chooseOneActions: [String: GameAction]
        public let handActions: [CardAction]
        public let occurredEvent: GameAction?

        public struct PlayerItem: Equatable {
            public enum Status {
                case active
                case idle
                case eliminated
            }

            public let id: String
            public let imageName: String
            public let displayName: String
            public let hand: String
            public let health: String
            public let equipment: String
            public let status: Status
        }

        public struct CardAction: Equatable {
            public let card: String
            public let action: GameAction?

            public init(card: String, action: GameAction?) {
                self.card = card
                self.action = action
            }
        }
    }
}
