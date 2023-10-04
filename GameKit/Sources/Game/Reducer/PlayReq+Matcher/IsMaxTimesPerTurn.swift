//
//  IsMaxTimesPerTurn.swift
//  
//
//  Created by Hugues Telolahy on 17/04/2023.
//

struct IsMaxTimesPerTurn: PlayReqMatcherProtocol {
    let maxTimes: ArgNum

    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        let argNumContext = ArgNumContext(actor: ctx.actor)
        guard let maxNumber = try? maxTimes.resolve(state: state, ctx: argNumContext) else {
            fatalError("unresolved numArg \(maxTimes)")
        }

        guard maxNumber > 0 else {
            return true
        }

        let cardName = ctx.card.extractName()
        let playedTimes = state.playCounter[cardName] ?? 0
        return playedTimes < maxNumber
    }
}
