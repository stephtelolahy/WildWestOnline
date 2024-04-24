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
    }
}
