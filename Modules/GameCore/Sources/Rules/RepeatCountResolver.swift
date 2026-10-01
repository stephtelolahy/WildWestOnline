//
//  RepeatCountResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//
extension Card.Selector.RepeatCount {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Int {
        switch self {
        case .times(let value):
            return value

        case .perPlayer:
            return state.playOrder.count

        case .perExcessHand:
            let playerObj = state.players.get(pendingAction.sourcePlayer)
            return max(playerObj.hand.count - playerObj.health, 0)

        case .perDamage:
            guard let parentAction = pendingAction.triggeredBy.first,
                  parentAction.name == .damage,
                  let amount = parentAction.amount else {
                fatalError("Expected trigger from damage")
            }

            return amount

        case .perRequiredMisses:
            let damageAction = state.queue[state.shotDamageIndex(target: pendingAction.targetedPlayer)]
            guard let requiredMisses = damageAction.requiredMisses else { fatalError("Missing requiredMisses") }
            return requiredMisses
        }
    }
}
