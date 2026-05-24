//
//  GameFeatureState+PendingChoice.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 21/11/2025.
//
public extension GameFeature.State {
    var pendingChoice: Card.Selector.ChoicePrompt? {
        guard let nextAction = queue.first,
              let selector = nextAction.selectors.first,
              case .choose(_, let status) = selector,
              case .prompted(let prompt) = status else {
            return nil
        }

        return prompt
    }
}
