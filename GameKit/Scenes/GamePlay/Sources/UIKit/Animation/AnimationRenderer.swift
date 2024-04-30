//
//  AnimationRenderer.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 04/04/2024.
//
import GameCore
import UIKit

protocol AnimationRendererProtocol {
    func execute(
        _ animation: EventAnimation,
        from initialState: GamePlayUIKitView.State,
        to finalState: GamePlayUIKitView.State,
        duration: TimeInterval
    )
}

protocol AnimationRendererConfiguration {
    func supportingViewController() -> UIViewController
    func cardPosition(for location: EventAnimation.Location) -> CGPoint
    func cardSize() -> CGSize
    func cardImage(for cardId: String) -> UIImage
    func hiddenCardImage() -> UIImage
}

struct AnimationRenderer: AnimationRendererProtocol {
    let config: AnimationRendererConfiguration

    func execute(
        _ animation: EventAnimation,
        from initialState: GamePlayUIKitView.State,
        to finalState: GamePlayUIKitView.State,
        duration: TimeInterval
    ) {
        switch animation {
        case let .move(card, source, target):
            config.supportingViewController().animateMoveCard(
                sourceImage: config.image(for: card, in: initialState),
                targetImage: config.image(at: target, in: initialState),
                size: config.cardSize(),
                from: config.cardPosition(for: source),
                to: config.cardPosition(for: target),
                duration: duration
            )

        case let .reveal(card, source, target):
            config.supportingViewController().animateRevealCard(
                sourceImage: config.image(for: card, in: initialState),
                targetImage: config.image(at: target, in: initialState),
                size: config.cardSize(),
                from: config.cardPosition(for: source),
                to: config.cardPosition(for: target),
                duration: duration
            )
        }
    }
}

private extension AnimationRendererConfiguration {
    func image(for card: EventAnimation.Card, in state: GamePlayUIKitView.State) -> UIImage {
        switch card {
        case .id(let cardId):
            return cardImage(for: cardId)

        case .topDeck:
            if let cardId = state.topDeck {
                return cardImage(for: cardId)
            } else {
                return hiddenCardImage()
            }

        case .topDiscard:
            if let cardId = state.topDiscard {
                return cardImage(for: cardId)
            } else {
                fatalError("missing discard image")
            }

        case .hidden:
            return hiddenCardImage()
        }
    }

    func image(at location: EventAnimation.Location, in state: GamePlayUIKitView.State) -> UIImage? {
        switch location {
        case .discard:
            if let cardId = state.topDiscard {
                return cardImage(for: cardId)
            } else {
                return nil
            }

        default:
            return nil
        }
    }
}
