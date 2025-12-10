//
//  GameFeatureState+Display.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 21/11/2025.
//
import Foundation

public extension GameFeature.State {
    func isTargeted(_ player: String) -> Bool {
        queue.contains { $0.targetedPlayer == player }
    }

    func pendingChoice(for player: String) -> PendingChoice? {
        guard let prompt = pendingChoice,
              prompt.chooser == player,
              let action = queue.first?.name else {
            return  nil
        }

        return .init(
            action: action,
            prompt: prompt
        )
    }

    func manuallyControlledPlayer() -> String? {
        playMode.keys.first { playMode[$0] == .manual }
    }

    var actionDelaySeconds: TimeInterval {
        Double(actionDelayMilliSeconds) / 1000.0
    }
}

public struct PendingChoice {
    public let action: Card.ActionName
    public let prompt: Card.Selector.ChoicePrompt
}
