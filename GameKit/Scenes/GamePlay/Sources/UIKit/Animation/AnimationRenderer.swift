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
        to finalState: GamePlayUIKitView.State
    )
}

protocol AnimationRendererConfiguration {
    func supportingViewController() -> UIViewController
    func cardPosition(for location: EventAnimation.Location) -> CGPoint
    func cardSize() -> CGSize
    func cardBackImage() -> UIImage
    func animationDuration() -> TimeInterval
}

struct AnimationRenderer: AnimationRendererProtocol {
    private let config: AnimationRendererConfiguration

    func execute(
        _ animation: EventAnimation,
        from initialState: GamePlayUIKitView.State,
        to finalState: GamePlayUIKitView.State
    ) {
        /*
        switch animation {
        case let .move(card, source, target):
            let sourceName = sourceImageName(for: card, in: state)
            let targetName = targetImageName(to: target, in: state)
            viewController?.animateMoveCard(sourceImage: UIImage.image(named: sourceName) ?? cardBackImage,
                                            targetImage: UIImage.image(named: targetName),
                                            size: cardSize,
                                            from: cardPositions[source]!,
                                            to: cardPositions[target]!,
                                            duration: animation.duration)

        case let .reveal(card, source, target):
            let sourceName = sourceImageName(for: card, in: state)
            let targetName = targetImageName(to: target, in: state)
            viewController?.animateRevealCard(sourceImage: UIImage.image(named: sourceName) ?? cardBackImage,
                                              targetImage: UIImage.image(named: targetName),
                                              size: cardSize,
                                              from: cardPositions[source]!,
                                              to: cardPositions[target]!,
                                              duration: animation.duration)
         }
         */
    }
}

private extension AnimationRenderer {
    private func sourceImageName(
        for card: String?,
        in state: GamePlayUIKitView.State
    ) -> String? {
        switch card {
//        case .topDeckCard:
//            return state.deck.first?.extractName()

        case .topDiscardCard:
            return state.topDiscard?.extractName()

        default:
            return card?.extractName()
        }
    }

    private func targetImageName(
        for location: EventAnimation.Location,
        in state: GamePlayUIKitView.State
    ) -> String? {
        if location == .discard {
            return state.topDiscard?.extractName()
        } else {
            return nil
        }
    }
}
