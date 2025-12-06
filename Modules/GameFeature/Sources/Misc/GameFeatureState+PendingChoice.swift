//
//  GameFeatureState+PendingChoice.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 21/11/2025.
//
import CardDefinition

public extension GameFeature.State {
    var pendingChoice: Card.Selector.ChoicePrompt? {
        guard let nextAction = queue.first,
              let selector = nextAction.selectors.first,
              case let .chooseOne(_, prompt, selection) = selector,
              selection == nil else {
            return nil
        }

        return prompt
    }
}
