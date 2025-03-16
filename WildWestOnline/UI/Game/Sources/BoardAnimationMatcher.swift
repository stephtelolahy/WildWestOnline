//
//  BoardAnimationMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/03/2025.
//
import GameCore

struct BoardAnimationMatcher {
    func animation(on action: GameAction, controlledPlayer: String?) -> AnimationKind? {
        switch action.kind {
        case .discardPlayed:
            let playerIsControlled = action.payload.target == controlledPlayer
            if playerIsControlled {
                return .moveCard(
                    .id(action.payload.card!),
                    from: .controlledHand(action.payload.card!),
                    to: .discard
                )
            } else {
                return .moveCard(
                    .id(action.payload.card!),
                    from: .playerHand(action.payload.target),
                    to: .discard
                )
            }

        default:
            return nil
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
    case controlledHand(String)
}

enum CardContent: Equatable {
    case id(String)
    case back
    case empty
}
