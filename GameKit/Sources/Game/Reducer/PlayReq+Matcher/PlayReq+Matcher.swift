//
//  PlayReq+Matcher.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

protocol PlayReqMatcherProtocol {
    func match(state: GameState, ctx: PlayReqContext) -> Bool
}

struct PlayReqContext {
    /// Player verifying requirement
    let actor: String

    /// Card matching requirement
    let card: String
}

extension PlayReq {
    func match(state: GameState, ctx: PlayReqContext) throws {
        let matched = matcher().match(state: state, ctx: ctx)
        guard matched else {
            throw GameError.noReq(self)
        }
    }
}

private extension PlayReq {
    // swiftlint:disable:next cyclomatic_complexity
    func matcher() -> PlayReqMatcherProtocol {
        switch self {
        case .onSetTurn:
            OnSetTurn()
        case .onLooseLastHealth:
            OnLooseLastHealth()
        case .onEliminated:
            OnEliminated()
        case .onPlayImmediate:
            OnPlayImmediate()
        case .onPlayHandicap:
            OnPlayHandicap()
        case .onPlayAbility:
            OnPlayAbility()
        case .onPlayEquipment:
            OnPlayEquipment()
        case let .onForceDiscardHandNamed(cardName):
            OnForceDiscardHandNamed(cardName: cardName)
        case .onDiscardedFromPlay:
            OnDiscardedFromPlay()
        case let .onPlayEquipmentWithAttribute(key):
            OnPlayEquipmentWithAttribute(key: key)
        case let .isPlayersAtLeast(minCount):
            IsPlayersAtLeast(minCount: minCount)
        case let .isMaxTimesPerTurn(maxTimes):
            IsMaxTimesPerTurn(maxTimes: maxTimes)
        case .isYourTurn:
            IsCurrentTurn()
        }
    }
}
