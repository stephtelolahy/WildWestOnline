//
//  SelectorResolver.swift
//
//  Created by Hugues Telolahy on 30/10/2024.
//
extension Card.Selector {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
        switch self {
        case .repeat(let count):
            return Array(repeating: pendingAction, count: count.resolve(pendingAction, state: state))

        case .target(let identity):
            guard let targets = identity.resolve(pendingAction, state: state) else {
                throw .noPlayer(identity)
            }

            return targets.map { pendingAction.copy(targetedPlayer: $0) }

        case .card(let identity):
            guard let cards = identity.resolve(pendingAction, state: state) else {
                throw .noCard(identity)
            }

            return cards.map { pendingAction.copy(targetedCard: $0, state: state) }

        case let .choose(choice, status):
            return try choice.resolve(status: status, pendingAction: pendingAction, state: state)

        case .require(let requirement):
            guard requirement.match(pendingAction, state: state) else {
                throw .noReq(requirement)
            }

            return [pendingAction]

        case .applyIf(let requirement):
            return requirement.match(pendingAction, state: state) ? [pendingAction] : []

        case .amount(let amount):
            var copy = pendingAction
            copy.amount = amount
            return [copy]
        }
    }
}
