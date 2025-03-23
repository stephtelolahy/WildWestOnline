//
//  NonStandardLogic.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/03/2025.
//

enum NonStandardLogic {
    /// Convert action.name to child action
    static func resolveCardSelection(
        _ selection: String,
        state: GameState,
        pendingAction: inout GameAction
    ) {
        if pendingAction.name == .discard {
            let targetObj = state.players.get(pendingAction.payload.target!)
            if targetObj.hand.contains(selection) {
                pendingAction.name = .discardHand
            } else if targetObj.inPlay.contains(selection) {
                pendingAction.name = .discardInPlay
            } else {
                fatalError("Unowned card \(selection)")
            }
        }

        if pendingAction.name == .steal {
            let targetObj = state.players.get(pendingAction.payload.target!)
            if targetObj.hand.contains(selection) {
                pendingAction.name = .stealHand
            } else if targetObj.inPlay.contains(selection) {
                pendingAction.name = .stealInPlay
            } else {
                fatalError("Unowned card \(selection)")
            }
        }
    }

    /// Determine child effect's target
    static func childEffectTarget(
        _ name: GameAction.Name,
        payload: GameAction.Payload
    ) -> String? {
        switch name {
        case .choose,
                .preparePlay,
                .play,
                .equip,
                .handicap,
                .draw,
                .discover,
                .stealHand,
                .stealInPlay,
                .passInPlay:
            payload.target

        default:
            payload.actor
        }
    }
}
