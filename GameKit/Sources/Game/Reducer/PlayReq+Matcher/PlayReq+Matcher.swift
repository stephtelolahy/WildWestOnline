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

    func throwingMatch(state: GameState, ctx: PlayReqContext) throws {
        let matched = matcher().match(state: state, ctx: ctx)
        guard matched else {
            throw GameError.noReq(self)
        }
    }
}

private extension PlayReq {
    // swiftlint:disable:next cyclomatic_complexity
    func matcher() -> PlayReqMatcher {
        switch self {
        case .setTurn:
            OnSetTurn()
        case .damage:
            OnDamage()
        case .damageLethal:
            OnDamageLethal()
        case .eliminated:
            OnEliminated()
        case .playImmediate:
            OnPlayImmediate()
        case .playHandicap:
            OnPlayHandicap()
        case .playAbility:
            OnPlayAbility()
        case .playEquipment:
            OnPlayEquipment()
        case .shot:
            OnShot()
        case .updateInPlay:
            OnUpdateInPlay()
        case .playWeapon:
            OnPlayWeapon()
        case let .isPlayersAtLeast(minCount):
            IsPlayersAtLeast(minCount: minCount)
        case let .isCardPlayedLessThan(cardName, playedMaxTimes):
            IsCardPlayedLessThan(cardName: cardName, playedMaxTimes: playedMaxTimes)
        case .isYourTurn:
            IsYourTurn()
        }
    }
}
