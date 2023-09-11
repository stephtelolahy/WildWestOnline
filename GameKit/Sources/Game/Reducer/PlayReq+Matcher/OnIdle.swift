//
//  OnIdle.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/09/2023.
//

struct OnIdle: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        if state.queue.isEmpty,
           state.isOver == nil,
           state.chooseOne == nil,
           ctx.get(.actor) == state.turn,
           state.playOrder.contains(ctx.get(.actor)),
           state.event?.isActivateCards != true {
            return true
        } else {
            return false
        }
    }
}

private extension GameAction {
    var isActivateCards: Bool {
        switch self {
        case .activateCards:
            true
        default:
            false
        }
    }
}
