// swiftlint:disable:this file_name
//
//  GamePlayUIKitViewState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/03/2024.
//
// swiftlint:disable nesting

import Foundation
import GameCore

public extension GamePlayUIKitView {
    struct State: Equatable {
        public let players: [PlayerItem]
        public let message: String
        public let chooseOneData: ChooseOneData?
        public let handActions: [CardAction]
        public let topDiscard: String?
        public let topDeck: String?
        public let animationDelay: TimeInterval
        public let startOrder: [String]
        public let deckCount: Int
        public let occurredEvent: GameAction?

        public struct PlayerItem: Equatable {
            public let id: String
            public let imageName: String
            public let displayName: String
            public let health: Int
            public let maxHealth: Int
            public let handCount: Int
            public let inPlay: [String]
            public let isTurn: Bool
            public let isTargeted: Bool
            public let isEliminated: Bool
            public let role: String?
            public let userPhotoUrl: String?
        }

        public struct CardAction: Equatable {
            public let card: String
            public let action: GameAction?

            public init(card: String, action: GameAction?) {
                self.card = card
                self.action = action
            }
        }

        public struct ChooseOneData: Equatable {
            public let choiceType: ChoiceType
            public let options: [String]
            public let actions: [String: GameAction]

            public init(
                choiceType: ChoiceType,
                options: [String],
                actions: [String: GameAction]
            ) {
                self.choiceType = choiceType
                self.options = options
                self.actions = actions
            }
        }
    }
}