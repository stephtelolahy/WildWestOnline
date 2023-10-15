//
//  PlayReq+Matcher.swift
//  
//
//  Created by Hugues Telolahy on 15/10/2023.
//

protocol PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool
}

struct PlayReqContext {
    let actor: String
}

extension PlayReq {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        matcher().match(state: state, ctx: ctx)
    }
}

private extension PlayReq {
    // swiftlint:disable:next cyclomatic_complexity
    func matcher() -> PlayReqMatcher {
        switch self {
        case .onSetTurn:
            OnSetTurn()
        case .onDamageLethal:
            OnDamageLethal()
        case .onEliminated:
            OnEliminated()
        case .onEliminatedYourTurn:
            OnEliminatedYourTurn()
        case .onPlayImmediate:
            OnPlayImmediate()
        case .onPlayHandicap:
            OnPlayHandicap()
        case .onPlayAbility:
            OnPlayAbility()
        case .onPlayEquipment:
            OnPlayEquipment()
        case .onShot:
            OnShot()
        case .onUpdateInPlay:
            OnUpdateInPlay()
        case .onPlayWeapon:
            OnPlayWeapon()
        }
    }
}
