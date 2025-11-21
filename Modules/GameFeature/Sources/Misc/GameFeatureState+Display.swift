//
//  GameFeatureState+Display.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 21/11/2025.
//

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
}

public struct PendingChoice {
    public let action: Card.ActionName
    public let prompt: Card.Selector.ChoicePrompt
}
