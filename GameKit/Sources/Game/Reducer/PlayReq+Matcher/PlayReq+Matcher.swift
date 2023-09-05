//
//  PlayReq+Matcher.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//

extension PlayReq {
    func match(state: GameState, ctx: EffectContext) throws {
        let matched = matcher().match(state: state, ctx: ctx)
        guard matched else {
            throw GameError.noReq(self)
        }
    }
}

protocol PlayReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool
}

private extension PlayReq {
    func matcher() -> PlayReqMatcherProtocol {
        switch self {
        case .onSetTurn:
            OnSetTurn()
        case .onLooseLastHealth:
            OnLooseLastHealth()
        case .onEliminated:
            OnEliminated()
        case .onPlayImmediate,
                .onPlayHandicap:
            PlayReqNeverMatch()
        case .onPlayAbility:
            OnPlayAbility()
        case .onPlayEquipment:
            OnPlayEquipment()
        case .onForceDiscardHandNamed(let cardName):
            OnForceDiscardHandNamed(cardName: cardName)
        case .onDiscardedFromPlay:
            OnDiscardedFromPlay()
        case let .isPlayersAtLeast(minCount):
            IsPlayersAtLeast(minCount: minCount)
        case let .isTimesPerTurn(maxTimes):
            IsTimesPerTurn(maxTimes: maxTimes)
        case .isYourTurn:
            IsCurrentTurn()
        default:
            fatalError("No matcher found for \(self)")
        }
    }
}

private struct PlayReqNeverMatch: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        false
    }
}
