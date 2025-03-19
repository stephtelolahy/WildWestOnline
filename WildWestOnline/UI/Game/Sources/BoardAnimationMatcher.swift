//
//  BoardAnimationMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/03/2025.
//
import GameCore

struct BoardAnimationMatcher {
    func animation(on action: GameAction) -> AnimationKind? {
        switch action.kind {
        case .discardPlayed:
                .moveCard(
                    .id(action.payload.card!),
                    from: .playerHand(action.payload.target),
                    to: .discard
                )

        default:
            nil
        }
    }
}

enum AnimationKind: Equatable {
    case moveCard(CardContent, from: ViewPosition, to: ViewPosition)
}

enum ViewPosition: Hashable {
    case deck
    case discard
    case playerHand(String)
    case playerInPlay(String)
}

enum CardContent: Equatable {
    case id(String)
    case back
}
