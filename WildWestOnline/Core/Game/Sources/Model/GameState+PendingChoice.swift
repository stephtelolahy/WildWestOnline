//
//  GameState+PendingChoice.swift
//
//  Created by Hugues Telolahy on 27/10/2024.
//

public extension GameFeature.State {
    var pendingChoice: Card.Selector.ChooseOneResolved? {
        guard let nextAction = queue.first,
              let selector = nextAction.selectors.first,
              case let .chooseOne(_, resolved, selection) = selector,
              let choice = resolved,
              selection == nil else {
            return nil
        }

        return choice
    }
}
