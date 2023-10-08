//
//  PlayReq+Matcher.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

protocol PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool
}

struct PlayReqContext {
    let actor: String
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
    func matcher() -> PlayReqMatcher {
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
        case let .onForceDiscardHand(cardName):
            OnForceDiscardHand(cardName: cardName)
        case let .onPlayEquipmentWithAttribute(key):
            OnPlayEquipmentWithAttribute(key: key)
        case .onUpdateInPlay:
            OnUpdateInPlay()
        case let .isPlayersAtLeast(minCount):
            IsPlayersAtLeast(minCount: minCount)
        case let .isCard(cardName, playedMaxTimes):
            IsCardPlayedMaxTimes(cardName: cardName, playedMaxTimes: playedMaxTimes)
        case .isYourTurn:
            IsCurrentTurn()
        }
    }
}
