//
//  AnimationController.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 28/03/2024.
//
import GameCore

struct AnimationController {
    let animationMatcher: AnimationEventMatcherProtocol
    let animationRenderer: AnimationRendererProtocol

    func handleEvent(_ event: GameAction, in state: GameState) {
        if let animation = animationMatcher.animation(on: event) {
            animationRenderer.execute(animation, in: state)
        }
    }
}
